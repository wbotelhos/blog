require 'spec_helper'

describe Article, '#index' do
  context 'when logged' do
    let!(:draft)   { FactoryGirl.create :article }
    let!(:article) { FactoryGirl.create :article_published }

    before do
      login
      visit articles_path
    end

    it 'access index page' do
      expect(current_path).to eq '/articles'
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
        expect(current_path).to eq slug_path(article.slug)
      end
    end

    context 'when click on permalink' do
      before { click_link article.slug }

      it 'redirects to the article page' do
        expect(current_path).to eq slug_path(article.slug)
      end
    end
  end
end
