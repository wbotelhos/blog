# coding: utf-8
require 'spec_helper'

describe Category, '#show' do
  context 'when has match' do
    let!(:category) { FactoryGirl.create :category, name: 'Ruby Drama' }
    let!(:article) { FactoryGirl.create :article_published, category_ids: [category.id], categories: [category] }

    before do
      visit root_path
      within 'aside' do
        click_link category.name
      end
    end

    it 'goes to show page' do
      current_path.should == '/categories/ruby-drama'
    end

    it 'displays the searched category' do
      find('#search-term').should have_content category.slug
    end

    it 'displays the match article' do
      within 'article' do
        page.should have_content article.title
      end
    end
  end

  context 'when has no match' do
    before { visit categories_show_path 'inexistent' }

    it 'show no result message' do
      page.should have_content 'Nenhuma categoria encontrada!'
    end
  end

  context 'when category is empty' do
    before { visit '/categories/' }

    it 'redirects to root path' do
      current_path.should == root_path
    end
  end
end
