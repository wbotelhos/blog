# coding: utf-8
require 'spec_helper'

describe Article do
  it "has a valid factory" do
    FactoryGirl.build(:article).should be_valid
  end

  let!(:article) { FactoryGirl.create :article, title: "City - São João del-rey ('!@#$\alive%ˆ&*~^]}", body: 'some body' }

  describe "#slug_id" do
    context "on save" do
      it "should sanitize as slug style" do
        article.slug.should == 'city-sao-joao-del-rey-alive'
      end
    end

    context "on update" do
      before do
        article.title = "New City - Aimorés-MG"
        article.save
      end

      it "should sanitize as slug style" do
        article.slug.should == 'new-city-aimores-mg'
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
        article.created_at = Time.zone.now
        article.published_at = nil
      end

      it "return the text 'Rascunho'" do
        article.status.should == "Rascunho"
      end
    end

    context "when it is published" do
      before do
        article.created_at = Time.zone.now
        article.published_at = Time.zone.now
      end

      it "return the text 'Publicado'" do
        article.status.should == "Publicado"
      end
    end
  end

  describe "with resuming text" do
    let(:article_more) { FactoryGirl.build :article, title: 'City - São João del-rey', body: "some #{Article::MORE_TAG} body" }

    describe "#text" do
      it "returns :body without #{Article::MORE_TAG} tag" do
        article_more.text.should == 'some body'
      end
    end

    describe "#resume" do
      context "when #{Article::MORE_TAG} is present" do
        it "resume the text" do
          article_more.resume.should == 'some ...'
        end
      end

      context "when #{Article::MORE_TAG} is missing" do
        it "not resume the text" do
          article.resume.should == 'some body'
        end
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
      before { article.published_at = Time.new(1984, 10, 23) }

      its(:day) { should eql 23 }
      its(:month) { should eql 10 }
      its(:year) { should eql 1984 }
    end
  end

  describe "#comments_to_mail" do
    before do
      FactoryGirl.create :comment, email: 'email1@email.com', article: article
      FactoryGirl.create :comment, email: 'email2@email.com', article: article
    end

    context "with duplicated e-mails" do
      before { FactoryGirl.create :comment, email: 'email1@email.com', article: article }

      it "returns distinct e-mails" do
        article.comments_to_mail.should have(2).comments
      end
    end

    context "with author's comment included" do
      let!(:author_comment) { FactoryGirl.create :comment_with_author, article: article }

      it "remove his comment" do
        article.comments_to_mail.should_not include author_comment
      end
    end
  end
end
