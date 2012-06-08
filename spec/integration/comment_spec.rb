# coding: utf-8

require "spec_helper"

describe "comments" do
  let(:article) { articles(:article) }

  let(:comment1) {
    FactoryGirl.create(:comment, {
      :article => article,
      :email => "email1@mail.com"
    })
  }

  let(:comment2) {
    FactoryGirl.create(:comment, {
      :article => article,
    })
  }

  it "return distinct" do
    article.comments.push(comment1, comment2)

    article.unique_comments.should have(2).items
  end
end
