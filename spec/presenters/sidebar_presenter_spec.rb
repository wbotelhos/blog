require 'spec_helper'

describe SidebarPresenter do
  let(:articles) { mock_model Article }
  let(:categories) { mock_model Category }
  let(:links) { mock_model Link }

  subject { SidebarPresenter.new }

  before do
    Article.stub_chain(:select, :published).and_return(articles)
    Category.stub(:scoped).and_return(categories)
    Link.stub(:scoped).and_return(links)
  end

  context "showing admin bar" do
    its(:admin) { should eql(partial: 'sidebar/admin') }
  end

  context "showing administrator bar" do
    its(:administrator) { should eql(partial: 'sidebar/administrator') }
  end

  context "showing articles bar" do
     its(:articles) { should eql(partial: 'sidebar/articles', locals: { articles: articles }) }
  end

  context "showing category bar" do
    its(:categories) { should eql(partial: 'sidebar/categories', locals: { categories: categories }) }
  end

  context "showing admin bar" do
    its(:links) { should eql(partial: 'sidebar/links', locals: { links: links }) }
  end
end
