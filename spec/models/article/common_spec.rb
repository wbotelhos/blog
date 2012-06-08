# coding: utf-8

require "spec_helper"

describe Article do
  let!(:article) { Article.new({ :title => "title", :body => "my text" }) }
  let!(:article_more) { Article.new({ :title => "title", :body => "my <!--more--> text" }) }

  describe "- resume function -" do
    context "when more tag is present -" do
      subject { article_more.resume }

      it "should resume the text" do
        should eql("my ...")
      end

      it "should append the reticence -" do
        should eql("my ...")
      end
    end

    context "when more tag is missing -" do
      subject { article.resume }

      it "should resume the text -" do
        should eql("my text...")
      end

      it "should to keep the original text" do
        should eql("my text...")
      end
    end
  end

end
