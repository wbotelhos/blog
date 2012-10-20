# coding: utf-8
require 'spec_helper'

describe Article do
  it "has a valid factory" do
    FactoryGirl.build(:article).should be_valid
  end

  let(:article) { FactoryGirl.create :article, title: "City - São João del-rey ('!@#$\alive%ˆ&*~^)", body: 'my text' }

  describe "#slug_id" do
    context "on save" do
      it "should sanitize as slug style" do
        article.title.should == 'city-sao-joao-del-rey-alive'
      end
    end

    context "on update" do
      before do
        article.title = "New City - Aimorés-MG"
        article.save
      end

      it "should sanitize as slug style" do
        article.title.should == 'new-city-aimores-mg'
      end
    end
  end

  describe "getting the status" do
    subject { article }

    context "when article is new" do
      before do
        article.created_at = nil
        article.published_at = nil
      end

      it "return the text 'Novo'" do
        article.status.should == "Novo"
      end
    end

    context "when it is a draft" do
      before do
        article.created_at = Time.now
        article.published_at = nil
      end

      it "return the text 'Rascunho'" do
        article.status.should == "Rascunho"
      end
    end

    context "when it is published" do
      before do
        article.created_at = Time.now
        article.published_at = Time.now
      end

      it "return the text 'Publicado'" do
        article.status.should == "Publicado"
      end
    end
  end

  let(:article_more) { FactoryGirl.build :article, title: 'City - São João del-rey', body: "my #{Article::MORE_TAG} text" }

  describe "#text" do
    it "returns :body without #{Article::MORE_TAG} tag" do
      article_more.text.should == 'my text'
    end
  end

  describe "#resume" do
    context "when #{Article::MORE_TAG} is present" do
      it "resume the text" do
        article_more.resume.should == 'my ...'
      end
    end

    context "when #{Article::MORE_TAG} is missing" do
      it "not resume the text" do
        article.resume.should == 'my text'
      end
    end
  end

  describe "building the date uri" do
    subject { article }

    context "when it is a draft" do
      before { article.published_at = nil }

      its(:day) { should == '00' }
      its(:month) { should == '00' }
      its(:year) { should == '0000' }
    end

    context "when it is published" do
      before { article.published_at = Date.new(1984, 10, 23) }

      its(:day) { should eql 23 }
      its(:month) { should eql 10 }
      its(:year) { should eql 1984 }
    end
  end

  let(:comment_1) { FactoryGirl.create :comment, email: 'email1@email.com', article: article }
  let(:comment_2) { FactoryGirl.create :comment, email: 'email2@email.com', article: article }
  let(:comment_3) { FactoryGirl.create :comment, email: 'email1@email.com', article: article }
  let(:comment_4_author) { FactoryGirl.create :comment_author, article: article }

  describe "#unique_comments" do
    it "remove all author's e-mail" do
      article.unique_comments.should_not include comment_4_author
    end

    it "returns a list of unique comment of an article based on email" do
      article.unique_comments.should have(2).comments
    end

    it "include the notifier e-mail" do
      article.unique_comments.should_not include comment_4_author
    end
  end
end
