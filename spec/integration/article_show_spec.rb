# coding: utf-8
require "spec_helper"

describe Article, "Show" do
  let!(:article) { FactoryGirl.create(:article) }

  before do
    visit slug_article_path(article.year, article.month, article.day, article.slug)
  end

  it "should redirects to show page" do
    current_path.should match(%r[/articles/\d+])
  end

  it "should remove <!--more--> tag" do
    page.should_not have_content("<!--more-->")
  end

end
