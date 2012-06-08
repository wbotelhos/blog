require "spec_helper"

describe "index" do
  let(:article) { articles(:article) }

  before do
    visit "/"
  end

  context "listing articles" do
    it "should have read more button" do
      page.should have_content("Leia mais")
    end
  end

  context "click read more" do
    it "redirects to the article page" do
      click_link "Leia mais..."
      current_path.should eql(article_path(article))
    end    
  end

  context "click artigo title" do
    xit "redirects to the article page" do
      find(".article").find("h2").click
      current_path.should eql(article_path(article))
    end
  end

end
