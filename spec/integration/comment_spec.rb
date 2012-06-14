# coding: utf-8
require "spec_helper"

describe Comment, "commons" do
  let!(:article) { FactoryGirl.create(:article) }
  let!(:comment1) { FactoryGirl.create(:comment, { :id => 1, :article => article, :email => "email1@mail.com" }) }
  let!(:comment2) { FactoryGirl.create(:comment, { :id => 2, :article => article, :email => "email2@mail.com" }) }

  it "should return distinct emails" do
    article.comments.push(comment1, comment2)
    article.unique_comments.should have(2).items
  end

end
