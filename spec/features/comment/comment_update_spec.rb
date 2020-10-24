# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'
require 'support/timer'

RSpec.describe Comment, '#update' do
  let!(:article) { FactoryBot.create :article, :published }
  let!(:comment) { FactoryBot.create :comment, commentable: article, created_at: Time.zone.local(2020) }
  let!(:user) { FactoryBot.create(:user) }

  it 'redirects to edit page' do
    login(user)

    visit slug_path article.slug

    within '.comments' do
      click_link 'Editar'
    end

    expect(page).to have_current_path "/articles/#{article.id}/comments/#{comment.id}/edit"
  end

  context 'change the values' do
    it 'works' do
      login(user)

      visit slug_path article.slug

      within '.comments' do
        click_link 'Editar'
      end

      fill_in 'comment_body', with: 'new body'
      fill_in 'comment_email', with: 'new-john@example.org'
      fill_in 'comment_name', with: 'new name'
      fill_in 'comment_url', with: 'http://example.org/new'

      uncheck 'comment_pending'

      click_button 'Atualizar'

      # redirects to the article page
      expect(page).to have_current_path slug_path(article.slug)

      # does not displays the author indicator
      expect(page).not_to have_content 'autor'

      # displays the time
      expect(page).to have_content '1 Jan 2020 00:00'

      # displays the edit link
      expect(page).to have_link 'Editar'

      # displays the answer link
      expect(page).to have_link 'Responder'

      # displays the commenter name
      expect(page).to have_link 'new name', href: 'http://example.org/new'

      # hides the pending message
      expect(page).not_to have_content 'pendente'
    end
  end
end
