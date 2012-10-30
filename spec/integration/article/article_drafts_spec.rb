# coding: utf-8
require 'spec_helper'

describe Article, "#drafts" do
  let!(:article_draft) { FactoryGirl.create :article_draft }
  let!(:article_published) { FactoryGirl.create :article_published }

  context "when logged" do
    let(:user) { FactoryGirl.create :user }

    before do
      login with: user.email
      click_link 'Admin!'
      click_link 'Rascunhos'
    end

    it "redirects to the drafts page" do
      current_path.should match %r(/articles/drafts)
    end

    it "do not display published record" do
      page.should have_content article_draft.title
    end

    it "display the draft record" do
      page.should have_content article_draft.title
      page.should have_content article_draft.body
      page.should have_content article_draft.categories.first.name
    end

    it "display edit link" do
      page.should have_link 'Editar Artigo', href: "/articles/#{article_draft.id}/edit"
    end
  end

  context "when unlogged" do
    before { visit drafts_articles_path }

    it "redirects to the login page" do
      current_path.should == login_path
    end

    it "displays error message" do
      page.should have_content 'Você precisa estar logado!'
    end
  end
end
