# coding: utf-8
require "spec_helper"

describe Article, "#show" do
  let!(:article) {
    FactoryGirl.create(:article, { :published_at => Date.new(2012, 10, 23) })
  }

  before do
    visit article_path(article.year, article.month, article.day, article.slug)
  end

  it "redirects to show page" do
    current_path.should match(%r[/2012/10/23/title-1])
  end

  context "displaying the resume" do
    it "remove <!--more--> tag" do
      page.should_not have_content("<!--more-->")
    end
  end

end
