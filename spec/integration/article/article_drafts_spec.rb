# coding: utf-8
require 'spec_helper'

describe Article, "#drafts" do
  let(:article_draft) { FactoryGirl.create(:article_draft) }
  let(:article_published) { FactoryGirl.create(:article_published) }

  context "when logged" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      login with: user.email
      click_link "Admin!"
      click_link "Rascunhos"
    end

    it "redirects to the drafts page" do
      current_path.should match(%r[/articles/drafts])
    end

    xit "should display the draft items" do
      page.should have_content(article_draft.title)
      page.should_not have_content(article_published.title)
    end
  end

  context "when unlogged" do
    before do
      visit drafts_articles_path
    end

    it "redirects to the login page" do
      current_path.should eql(login_path)
    end

    it "displays error message" do
      page.should have_content("Você precisa estar logado!")
    end
  end

end
