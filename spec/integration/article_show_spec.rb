# coding: utf-8
require "spec_helper"

describe "Article show" do
  let!(:article) { articles(:article) }

  before do
    visit article_path(article)
  end

  it "should redirects to show page" do
    current_path.should match(%r[/articles/\d+])
  end

  it "should remove <!--more--> tag" do
    page.should_not have_content("<!--more-->")
  end

end
