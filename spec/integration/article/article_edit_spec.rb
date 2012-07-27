# coding: utf-8
require "spec_helper"

describe Article, "#create" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:article_draft) { FactoryGirl.create(:article_draft) }
  let!(:article_published) { FactoryGirl.create(:article_published) }

  before do
    login :with => user.email
  end

  context "when article is draft" do
    before do
      visit edit_article_path(article_draft)
    end

    it "display draft indicator" do
      page.should have_selector("div#status", :text => "Rascunho")
    end

    it "show preview link" do
      page.should_not have_selector("div#url a", :text => "Visualizar")
    end
  end

  context "when article is published" do
    before do
      visit edit_article_path(article_published)
    end

    it "display published indicator" do
      page.should have_selector("div#status", :text => "Publicado")
    end

    it "hide publish button" do
      page.should_not have_button("Publicar")
    end

    it "show slug link" do
      page.should_not have_selector("div#url a", :text => article_published.slug)
    end
  end

  context "when execute update" do
    before do
      visit edit_article_path(article_published)
      click_button "Atualizar"
    end

    it "redirects to the article page" do
      current_path.should match(%r[/articles/#{article_published.id}/edit])
    end

    it "displays success message" do
      page.should have_content("Artigo atualizado com sucesso!")
    end
  end

  context "when execute publish" do
    before do
      visit edit_article_path(article_draft)
      click_button "Publicar"
    end

    xit "redirects to the article page" do
      current_path.should eql(slug_article_path(article_draft.year, article_draft.month, article_draft.day, article_draft.slug))
    end

    xit "displays success message" do
      page.should have_content("Artigo publicado com sucesso!")
    end
  end
end
