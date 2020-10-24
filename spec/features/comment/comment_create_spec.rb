# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'
require 'support/timer'

RSpec.describe Comment, '#create' do
  let(:article) { FactoryBot.create :article, :published }

  context 'when unlogged' do
    before do
      logout
      visit slug_path article.slug
    end

    it 'shows the name field' do
      expect(page).to have_field 'comment_name'
    end

    it 'shows the email field' do
      expect(page).to have_field 'comment_email'
    end

    it 'shows the url field' do
      expect(page).to have_field 'comment_url'
    end

    it 'shows the body field' do
      expect(page).to have_field 'comment_body'
    end

    context 'with valid data' do
      let(:comment) { FactoryBot.build :comment }

      it 'works', :js do
        fill_in 'comment_body', with: comment.body
        fill_in 'comment_email', with: comment.email
        fill_in 'comment_name', with: comment.name
        fill_in 'comment_url', with: comment.url

        uncheck 'not_human'

        travel_to(Time.zone.local(2020)) do
          click_button 'Comentar'
        end

        # redirects to the article page
        expect(page).to have_current_path "/#{article.slug}"

        # does not displays the author indicator
        expect(page).not_to have_content 'autor'

        # displays the time
        expect(page).to have_content '1 Jan 2020 00:00'

        # displays the edit link
        expect(page).not_to have_link 'Editar'

        # displays the answer link
        expect(page).to have_link 'Responder'

        # displays the commenter name
        expect(page).to have_link comment.name, href: comment.url
      end
    end

    context 'with invalid data', :js do
      before { page.execute_script "$('#new_comment :input').removeAttr('required')" }

      context 'given empty name' do
        it 'displays error message' do
          fill_in 'comment_body', with: 'Some comment!'
          fill_in 'comment_email', with: 'john@example.org'
          fill_in 'comment_url', with: 'http://example.org'

          uncheck 'not_human'

          click_button 'Comentar'

          expect(page).to have_content 'O campo "Nome" deve ser preenchido!'
        end
      end

      context 'given empty email' do
        before do
          fill_in 'comment_body', with: 'Some comment!'
          fill_in 'comment_name', with: 'John'
          fill_in 'comment_url', with: 'http://example.org'

          uncheck 'not_human'

          click_button 'Comentar'
        end

        it 'displays error message' do
          expect(page).to have_content 'O campo "E-mail" deve ser preenchido!'
        end
      end

      context 'given empty body' do
        before do
          fill_in 'comment_email', with: 'john@example.org'
          fill_in 'comment_name', with: 'John'
          fill_in 'comment_url', with: 'http://example.org'

          uncheck 'not_human'

          click_button 'Comentar'
        end

        it 'displays error message' do
          expect(page).to have_content 'O campo "Comentário" deve ser preenchido!'
        end
      end
    end

    context 'answering', :js do
      let!(:comment) { FactoryBot.create :comment, commentable: article }

      before do
        visit slug_path article.slug

        within "#comment-#{comment.id}" do
          click_link 'Responder'
        end
      end

      it { expect(find_field('comment_body').value).to eq "#{comment.name},\n\n" }

      it 'shows the answer explanation' do
        expect(page).to have_content "Em resposta: ##{comment.id} #{comment.name}"
      end

      it 'shows the answer explanation anchor' do
        expect(page).to have_link "##{comment.id}", href: "#comment-#{comment.id}"
      end
    end

    describe '#AntiBOT', :js do
      it 'starts checked' do
        expect(page).to have_checked_field 'not_human'
      end

      it 'starts with bot log' do
        expect(page).to have_content 'BOT!'
      end

      context 'on uncheck' do
        before { uncheck 'not_human' }

        it 'logs human message' do
          expect(page).to have_content 'Humanos! <3'
        end

        context 'on check' do
          before { check 'not_human' }

          it 'log human message' do
            expect(page).to have_content 'Sério?'
          end

          context 'and submit' do
            before { click_button 'Comentar' }

            it 'blocks and shows exclamation message' do
              expect(page).to have_content 'Hey! Me desmarque.'
            end
          end
        end
      end
    end
  end

  context 'when logged' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      login(user)

      visit slug_path article.slug
    end

    it 'hides the name field' do
      expect(page).not_to have_field 'comment_name'
    end

    it 'hides the email field' do
      expect(page).not_to have_field 'comment_email'
    end

    it 'hides the url field' do
      expect(page).not_to have_field 'comment_url'
    end

    context 'with valid data' do
      it 'works' do
        fill_in 'comment_body', with: 'Some comment!'

        travel_to(Time.zone.local(2020)) do
          click_button 'Comentar'
        end

        # redirects to the article page
        expect(page).to have_current_path slug_path(article.slug)

        # displays the author indicator
        expect(page).to have_content 'autor'

        # displays the time
        expect(page).to have_content '1 Jan 2020 00:00'

        # displays the edit link
        expect(page).to have_link 'Editar'

        # displays the answer link
        expect(page).to have_link 'Responder'

        # displays the commenter name
        expect(page).to have_link CONFIG['author'], href: CONFIG['url_http']

        # does not begins pending
        expect(page).not_to have_content 'pendente'
      end
    end

    context 'answering', :js do
      let!(:comment) { FactoryBot.create :comment, commentable: article }

      before do
        visit slug_path article.slug

        within "#comment-#{comment.id}" do
          click_link 'Responder'
        end
      end

      it { expect(find_field('comment_body').value).to eq "#{comment.name},\n\n" }

      it 'shows the answer explanation' do
        expect(page).to have_content "Em resposta: ##{comment.id} #{comment.name}"
      end

      it 'shows the answer explanation anchor' do
        expect(page).to have_link "##{comment.id}", href: "#comment-#{comment.id}"
      end
    end
  end
end
