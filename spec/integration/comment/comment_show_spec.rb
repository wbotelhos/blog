# coding: utf-8
require 'spec_helper'

describe Comment, "Article#show" do
  let(:user) { FactoryGirl.create :user }
  let(:article) { FactoryGirl.create :article_published, user: user }
  let(:path) { article_path(article.year, article.month, article.day, article.slug) }
  let(:comment) { FactoryGirl.create :comment, article: article }

  before { visit path }

  context "when logged" do
    before do
      login with: user.email
      visit path
    end

    it "edit fields are hidden"

    context "when double click on comment" do
      it "show fields form"
    end
  end

  context "when unlogged" do
    before { visit path }

    it "edit fields are hidden"

    context "when double click on comment" do
      it "do not show fields form"
    end
  end
end
