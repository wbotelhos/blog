require 'spec_helper'

describe Article, '_articles' do
  context 'with article' do
    let!(:article) { FactoryGirl.create :article_published }
    let(:path) { article_path(article.year, article.month, article.day, article.slug) }

    before { visit root_path }

    it 'shows the section title' do
      within 'aside' do
        page.should have_content 'Artigos'
      end
    end

    it 'shows the article' do
      within 'aside' do
        page.should have_link article.title, href: path
      end
    end
  end

  context 'without article' do
    before { visit root_path }

    it 'hides the section title' do
      within 'aside' do
        page.should_not have_content 'Artigos'
      end
    end
  end
end
