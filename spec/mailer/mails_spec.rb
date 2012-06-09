# coding: utf-8
require "spec_helper"

describe Mailer do
  let!(:article)      { FactoryGirl.create(:article) }
  let!(:new_comment)  { FactoryGirl.create(:comment) }
  let!(:comment)      { FactoryGirl.create(:comment) }
  let(:mailer)        { Mailer.comment(article, new_comment, comment) }

  context "configurations" do
    it { mailer.should_not be_multipart }

    it "should queue email" do
      lambda { mailer.deliver }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end

  end

  context "informations" do
    it { mailer.to.first.should eql(comment.email) }
    it { mailer.from.first.should eql("noreply@wbotelhos.com.br") }
    it { mailer.bcc.first.should eql("wbotelhos@gmail.com") }
    it { mailer.subject.should eql("Artigo respondido") }
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
