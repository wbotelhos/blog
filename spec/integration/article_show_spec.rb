# coding: utf-8
require "spec_helper"

describe Article, "Show" do
  let!(:article) {
    FactoryGirl.create(:article, {
      :title => "title 1",
      :published_at => Date.new(2012, 10, 23)
    })
  }

  before do
    visit slug_article_path(article.year, article.month, article.day, article.slug)
  end

  it "should redirects to show page" do
    current_path.should match(%r[/2012/10/23/title-1])
  end

  it "should remove <!--more--> tag" do
    page.should_not have_content("<!--more-->")
  end

end
