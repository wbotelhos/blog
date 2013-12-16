# coding: utf-8

require 'spec_helper'

describe Comment, '#create' do
  let(:article) { FactoryGirl.create :article_published }

  context 'when logged' do
    before do
      @user = login

      visit slug_path article.slug
    end

    context 'with valid data' do
      before do
        fill_in 'comment_body', with: 'Some comment!'

        click_button 'COMENTAR'
      end

      it 'redirects to the article page' do
        expect(current_path).to eq slug_path(article.slug)
      end

      it 'displays comment' do
        within '#comment-1' do
          expect(page).to have_content 'autor'
          expect(page).to have_content 'menos de um minuto atrás'
          expect(page).to have_link    '#1'                       , href: '#comment-1'
          expect(page).to have_link    'Editar'
          expect(page).to have_link    'Responder'
          expect(page).to have_link    @user.name                 , href: CONFIG['url']
        end
      end
    end
  end

  context 'when unlogged' do
    context 'with valid data' do
      before do
        visit slug_path article.slug

        fill_in 'comment_body'  , with: 'Some comment!'
        fill_in 'comment_email' , with: 'john@example.org'
        fill_in 'comment_name'  , with: 'John'
        fill_in 'comment_url'   , with: 'http://example.org'

        uncheck 'not_human'

        click_button 'COMENTAR'
      end

      it 'redirects to the article page' do
        current_path.should == slug_path(article.slug)
      end

       xit 'displays comment' do
         page.should have_content 'some name'
         page.should have_content 'some comment'
       end
    end

    context 'with invalid data', :js do
      before do
        visit slug_path article.slug

        page.execute_script "$('#new_comment :input').removeAttr('required')"
      end

      context 'given empty name' do
        before do
          fill_in 'comment_body'  , with: 'Some comment!'
          fill_in 'comment_email' , with: 'john@example.org'
          fill_in 'comment_url'   , with: 'http://example.org'

          uncheck 'not_human'
        end

        it 'displays error message' do
          page.should have_content 'O campo "Nome" deve ser preenchido!'
        end
      end

      context 'given empty email' do
        before do
          fill_in 'comment_body'  , with: 'Some comment!'
          fill_in 'comment_name'  , with: 'John'
          fill_in 'comment_url'   , with: 'http://example.org'

          uncheck 'not_human'

          click_button 'COMENTAR'
        end

        it 'displays error message' do
          page.should have_content 'O campo "E-mail" deve ser preenchido!'
        end
      end

      context 'given empty body' do
        before do
          fill_in 'comment_email' , with: 'john@example.org'
          fill_in 'comment_name'  , with: 'John'
          fill_in 'comment_url'   , with: 'http://example.org'

          uncheck 'not_human'

          click_button 'COMENTAR'
        end

        it 'displays error message' do
          page.should have_content 'O campo "Comentário" deve ser preenchido!'
        end
      end
    end
  end
end
