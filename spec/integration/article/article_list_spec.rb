# coding: utf-8
require 'spec_helper'

describe Article, "#list" do
  let(:article_draft) { FactoryGirl.create(:article_draft) }
  let(:article_published) { FactoryGirl.create(:article_published) }

  before do
    visit "/"
  end

  context "when there is draft article" do
    xit "display just the published" do
      page.should have_content(article_published.title)
      page.should_not have_content(article_draft.title)
    end
  end
end
