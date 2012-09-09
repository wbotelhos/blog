# coding: utf-8
require "spec_helper"

describe Mailer do
  let!(:article)      { FactoryGirl.create(:article_published) }
  let!(:new_comment)  { FactoryGirl.create(:comment) }
  let!(:comment)      { FactoryGirl.create(:comment) }
  let!(:mailer)       { Mailer.comment(article, new_comment, comment) }
  let!(:slug_title)   { "#{article.year}/#{article.month}/#{article.day}/#{article.slug}" }

  context "during the configuration" do
    it { mailer.should be_multipart }
    it { mailer.to.first.should eql(comment.email) }
    it { mailer.from.first.should eql("noreply@#{CONFIG["url"]}") }
    it { mailer.bcc.first.should eql(CONFIG["email"]) }
    it { mailer.subject.should eql("Artigo respondido") }

    it "queue the email" do
      lambda { mailer.deliver }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end

  context "building the content parts" do
    it "has the right html body" do
      body = mailer.parts.first.body

      body.should match(%r[<title>#{CONFIG["author"]}</title>])
      body.should match(%r[<h1><a href="#{CONFIG['url_http']}" target="_blank" style="color: #333; font-size: 47px; letter-spacing: -3px; text-decoration: none; text-shadow: 2px 2px #FFF;">#{CONFIG["author"]}</a></h1>])
      body.should match(%r[Ol&aacute;])
      body.should match(%r[<strong>#{comment.name}</strong>,])
      body.should match(%r[O artigo <strong><a href="#{CONFIG['url_http']}/#{slug_title}" style="color: #277DA8; text-decoration: none;">#{article.title}</a></strong> no qual voc&ecirc; participou foi respondido por <strong>#{new_comment.name}</strong>.])
      body.should match(%r[N&atilde;o perca a discuss&atilde;o, visite: <a href="#{CONFIG['url_http']}/#{slug_title}#comment-#{new_comment.id}" style="color: #277DA8; text-decoration: none;">http://#{CONFIG["url"]}/#{slug_title}#comment-#{new_comment.id}</a>])
      body.should match(%r[<a href="#{CONFIG['url_http']}" target="_blank" style="color: #4080BF; text-decoration: none;">#{CONFIG["url_www"]}</a><br />])
      body.should match(%r[<div style="font-size: 11px;">#{CONFIG["description"]}</div>])
    end

    it "has the text body" do
      body = mailer.parts.last.body

      body.should include(%[Olá #{comment.name},])
      body.should include(%[O artigo "#{article.title}" no qual você participou foi respondido por #{new_comment.name}.])
      body.should include(%[Não perca a discussão, visite: #{CONFIG["url_http"]}/#{slug_title}#comment-#{new_comment.id}])
      body.should include(%[---])
      body.should include(CONFIG["author"])
      body.should include(CONFIG["url_http"])
    end
  end

end
