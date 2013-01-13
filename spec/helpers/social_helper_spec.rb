require 'spec_helper'

describe SocialHelper do
  describe '#twitter_button' do
    let(:article) { FactoryGirl.build :article_published }
    let(:url) { article_url article.year, article.month, article.day, article.slug }
    let(:via) { 'wbotelhos' }
    let(:title) { CGI.escape article.title }
    let(:scaped_url) { CGI.escape url }
    let(:href) { "https://twitter.com/intent/tweet?text=%22#{title}%22&amp;url=#{scaped_url}&amp;via=#{via}" }
    let(:button) { %(<div id="twitter"><a href="#{href}" target="_blank">Tweet</a></div>) }

    it 'builds the html button' do
      helper.twitter_button(text: article.title, url: url).should == button
    end
  end

  describe '#social_icon' do
    let(:icon) { 'icon.png' }
    let(:title) { 'title' }
    let(:url) { 'http://url.com' }

    subject { helper.social_icon icon, title, url }

    it 'builds the html icon link' do
      subject.should match %(href="#{url}" target="_blank")
      subject.should match %(alt="#{title}")
      subject.should match %(title="#{title}")
      subject.should match %(src="/images/#{icon}")
    end
  end

  describe '#author_social' do
    let(:user) { FactoryGirl.build :user, bio: 'bio.com', github: 'github.com', linkedin: 'linkedin.com', twitter: 'twitter.com', facebook: 'facebook.com' }
    let(:md5) { Digest::MD5.hexdigest user.email }

    subject { helper.author_social user }

    it 'builds the html' do
      subject.should match 'href="github.com"'
      subject.should match 'href="linkedin.com"'
      subject.should match 'href="twitter.com"'
      subject.should match 'href="facebook.com"'
      subject.should match 'class="github"'
      subject.should match 'class="linkedin"'
      subject.should match 'class="twitter"'
      subject.should match 'class="facebook"'
    end
  end
end
