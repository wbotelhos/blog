# coding: utf-8
require "spec_helper"

describe "index" do
  let!(:article) { FactoryGirl.create(:article_published) }

  before do
    visit "/"
  end

  context "when listing articles" do
    it "have read more button" do
      page.should have_content("Leia mais")
    end

    context "with no one to show" do
      it "hide page controls" do
        page.should_not have_selector("span", :text => "Página 1")
      end
    end
  end

  context "when click read more" do
    it "redirects to the article page" do
      click_link "Leia mais..."
      current_path.should eql(slug_article_path(article.year, article.month, article.day, article.slug))
    end    
  end

  context "when click artigo title" do
    xit "redirects to the article page" do
      find(".article").find("h2").click
      current_path.should eql(slug_article_path(article.year, article.month, article.day, article.slug))
    end
  end

end
