# coding: utf-8
require "spec_helper"

describe Article, "#create" do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    login :with => user.email
  end

  context "when article is draft" do
    let!(:article) {
      FactoryGirl.create(:article, { :created_at => Time.now, :published_at => nil })
    }

    before do
      visit edit_article_path(article)
    end

    it "display draft indicator" do
      page.should have_selector("div#status", :text => "Rascunho")
    end
  end

  context "when article is published" do
    let!(:article) {
      FactoryGirl.create(:article, { :created_at => Time.now, :published_at => Time.now })
    }

    before do
      visit edit_article_path(article)
    end

    it "display published indicator" do
      page.should have_selector("div#status", :text => "Publicado")
    end
  end
end
