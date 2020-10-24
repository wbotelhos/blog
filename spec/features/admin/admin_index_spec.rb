# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe 'Admin', '#index' do
  context 'when logged' do
    let!(:user) { FactoryBot.create(:user) }

    before { login(user) }

    context 'article' do
      let!(:draft)     { FactoryBot.create :article, published_at: nil }
      let!(:published) { FactoryBot.create :article, :published }

      before { visit admin_path }

      it 'access index page' do
        expect(page).to have_current_path '/admin'
      end

      it 'do not display published record' do
        expect(page).to have_no_content published.title
      end

      it 'display the drafts' do
        expect(page).to have_content draft.title
        expect(page).to have_content draft.slug
      end

      it 'shows the drafts title' do
        expect(page).to have_content 'Rascunhos'
      end

      context 'when click on title' do
        before { click_link draft.title }

        it 'redirects to edit page' do
          expect(page).to have_current_path edit_article_path(draft.id), ignore_query: true
        end
      end

      context 'when click on permalink' do
        before { click_link draft.slug }

        it 'redirects to the draft page' do
          expect(page).to have_current_path slug_path(draft.slug), ignore_query: true
        end
      end
    end
  end
end
