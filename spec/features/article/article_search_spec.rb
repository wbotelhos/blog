# coding: utf-8
require 'spec_helper'

describe Article, '#search', js: true do
  context 'when has match term' do
    let(:term) { 'skate' }
    let(:category) { FactoryGirl.create :category }
    let!(:article) { FactoryGirl.create :article_published, title: 'skate', categories: [category] }

    before do
      visit root_path
      fill_in 'query', with: term
      page.execute_script "$('.search').submit();"
    end

    it 'display the searched term' do
      within 'section' do
        find('#search-term').should have_content term
      end
    end

    xit 'display the match article' do
      within 'section' do
        page.should have_content 'skate'
      end
    end

    it 'go to search page' do
      current_path.should match %r(/articles/search)
    end
  end

  context 'when query is empty' do
    before do
      visit root_path
      fill_in 'query', with: ''
      page.execute_script "$('.search').submit();"
    end

    it 'redirects to root path' do
      current_path.should == root_path
    end
  end
end
