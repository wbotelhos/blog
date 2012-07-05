require "spec_helper"

describe "index" do
  let!(:article) { FactoryGirl.create(:article) }

  before do
    visit "/"
  end

  context "listing articles" do
    it "should have read more button" do
      page.should have_content("Leia mais")
    end
  end

  context "click read more" do
    it "should redirects to the article page" do
      click_link "Leia mais..."
      current_path.should eql(slug_article_path(article.year, article.month, article.day, article.slug))
    end    
  end

  context "should click artigo title" do
    xit "redirects to the article page" do
      find(".article").find("h2").click
      current_path.should eql(slug_article_path(article.year, article.month, article.day, article.slug))
    end
  end

end
