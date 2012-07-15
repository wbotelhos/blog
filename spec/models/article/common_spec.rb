# coding: utf-8

require "spec_helper"

describe Article do
  let!(:article) { Article.new({ :title => %[City - São João del-rey ('!@#$\alive%ˆ&*~^)], :body => "my text" }) }
  let!(:article_more) { Article.new({ :title => "City - São João del-rey", :body => "my <!--more--> text" }) }

  describe "resume function" do
    context "when more tag is present" do
      subject { article_more.resume }

      it "should resume the text" do
        should eql("my ...")
      end

      it "should append the reticence -" do
        should eql("my ...")
      end
    end

    context "when more tag is missing" do
      subject { article.resume }

      it "should resume the text -" do
        should eql("my text...")
      end

      it "should to keep the original text" do
        should eql("my text...")
      end
    end
  end

  describe "slug title" do
    subject { article.slug_it(article.title) }

    it "should slug letter and spaces" do
      should eql("city-sao-joao-del-rey-alive")
    end
  end

  describe "slug date" do
    context "when it is a draft yet" do
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

  describe "status" do
    subject { article }

    context "when article is new" do
      before do
        article.created_at = nil
        article.published_at = nil
      end

      it "return 'Novo'" do
        article.status.should == "Novo"
      end
    end

    context "when article is a draft" do
      before do
        article.created_at = Time.now
        article.published_at = nil
      end

      it "return 'Rascunho'" do
        article.status.should == "Rascunho"
      end
    end

    context "when article is published" do
      before do
        article.created_at = Time.now
        article.published_at = Time.now
      end

      it "return 'Publicado'" do
        article.status.should == "Publicado"
      end
    end
  end

end
