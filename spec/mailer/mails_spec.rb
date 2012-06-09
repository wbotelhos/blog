# coding: utf-8
require "spec_helper"

describe Mailer do
  let!(:article)      { FactoryGirl.create(:article) }
  let!(:new_comment)  { FactoryGirl.create(:comment) }
  let!(:comment)      { FactoryGirl.create(:comment) }
  let(:mailer)        { Mailer.comment(article, new_comment, comment) }

  context "build" do
    it "should queue email" do
      lambda { mailer.deliver }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end

  context "configurations" do
    it { mailer.should_not be_multipart }
  end

  context "informations" do
    it "should have the right to" do
      mailer.to.first.should eql(comment.email)
    end

    it "should have the right subject" do
      mailer.subject.should eql("Artigo respondido")
    end

    it "should have the right from" do
      mailer.from.should include("noreply@wbotelhos.com.br")
    end
  end

  context "content" do
    it "should have the hello message" do
      mail = mailer.deliver

      mail.body.should include("Olá #{comment.name},")
      mail.body.should include(%[O article "#{article.title}" no qual você participou foi respondido por #{new_comment.name}.])
      mail.body.should include(%[Não perca a discussão, visite: http://wbotelhos.com.br/articles/#{article.id}#comment-#{new_comment.id}])
    end
  end

end
