# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe Article, '#index' do
  context 'when logged' do
    let!(:draft)   { FactoryBot.create :article }
    let!(:article) { FactoryBot.create :article, :published }
    let!(:user) { FactoryBot.create(:user) }

    before do
      login(user)
      visit articles_path
    end

    it 'access index page' do
      expect(page).to have_current_path '/articles'
    end

    it 'do not display draft record' do
      expect(page).to have_no_content draft.title
    end

    it 'display the articles' do
      expect(page).to have_content article.title
      expect(page).to have_content article.slug
    end

    it 'shows the year and month of publication' do
      expect(page).to have_content article.published_at.strftime('%m/%Y')
    end

    context 'when click on title' do
      before { click_link article.title }

      it 'redirects to the article page' do
        expect(page).to have_current_path slug_path(article.slug)
      end
    end

    context 'when click on permalink' do
      before { click_link article.slug }

      it 'redirects to the article page' do
        expect(page).to have_current_path slug_path(article.slug)
      end
    end
  end
end
