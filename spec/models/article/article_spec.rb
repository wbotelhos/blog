# coding: utf-8
require "spec_helper"

describe Article do
  it "has a valid factory" do
    FactoryGirl.build(:article).should be_valid
  end

  let!(:article) { Article.new({ :title => %[City - São João del-rey ('!@#$\alive%ˆ&*~^)], :body => "my text" }) }
  let!(:article_more) { Article.new({ :title => "City - São João del-rey", :body => "my <!--more--> text" }) }

  describe "resuming the article" do
    context "when the tag more is present" do
      subject { article_more.resume }

      it "resume the text" do
        should eql("my ...")
      end

      it "append the reticence -" do
        should eql("my ...")
      end
    end

    context "when the tag more is missing" do
      subject { article.resume }

      it "not resume the text" do
        should eql("my text")
      end

      it "not append reticence" do
        should eql("my text")
      end
    end
  end

  describe "slugging the title" do
    subject { article.slug_it(article.title) }

    it "replace white spaces" do
      should eql("city-sao-joao-del-rey-alive")
    end
  end

  describe "building the date uri" do
    context "when it is a draft" do
      before do
        article.published_at = nil
      end

      subject { article }

      its(:day) { should eql("00") }
      its(:month) { should eql("00") }
      its(:year) { should eql("0000") }
    end

    context "when it is published" do
      before do
        article.published_at = Date.new(1984, 10, 23)
      end

      subject { article }

      its(:day) { should eql(23) }
      its(:month) { should eql(10) }
      its(:year) { should eql(1984) }
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

end
