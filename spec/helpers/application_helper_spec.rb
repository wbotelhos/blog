# coding: utf-8

require 'spec_helper'
require 'digest/md5'

describe ApplicationHelper do
  describe '#gravatar' do
    let(:email) { 'wbotelhos@gmail.com' }
    let(:md5) { Digest::MD5.hexdigest email }

    context 'without :size' do
      subject { helper.gravatar email }

      it 'build a image' do
        subject.should match %r(src="http://www\.gravatar\.com/avatar/#{md5}\?d=mm")
      end
    end

    context 'without alt parameter' do
      subject { helper.gravatar email }

      it 'builds the html with empty alt' do
        subject.should match 'alt=""'
      end
    end

    context 'with alt parameter' do
      subject { helper.gravatar email, alt: 'alt' }

      it 'builds the html with alt' do
        subject.should match 'alt="alt"'
      end
    end
  end

  describe '#author' do
    let(:user) { FactoryGirl.build :user, bio: 'bio.com', github: 'github.com', linkedin: 'linkedin.com', twitter: 'twitter.com', facebook: 'facebook.com' }
    let(:md5) { Digest::MD5.hexdigest user.email }

    subject { helper.author user }

    it 'builds the html' do
      subject.should match 'alt=""'
      subject.should match %r(src="http://www\.gravatar\.com/avatar/#{md5}\?d=mm")
      subject.should match '<div class="biography"><p>bio.com</p></div>'
      subject.should match '<div class="social">'
      subject.should match 'href="github.com"'
      subject.should match 'href="linkedin.com"'
      subject.should match 'href="twitter.com"'
      subject.should match 'href="facebook.com"'
    end
  end

  describe '#logo' do
    it 'builds the html' do
      helper.logo.should == '<div id="logo"><h1><a href="/">Washington Botelho</a></h1><p>Se você não tem dom, tenha vontade!</p></div>'
    end
  end

  describe '#markdown' do
    it 'works' do
      helper.markdown('**strong within p**').should == "<p><strong>strong within p</strong></p>\n"
    end
  end

  describe '#title' do
    context 'without section and content_for' do
      it 'returns just the author name' do
        helper.title.should == 'Washington Botelho'
      end
    end

    context 'with manual section' do
      it 'returns the author name with the manual name' do
        helper.title('manual-title').should == 'Washington Botelho | manual-title'
      end
    end

    context 'with content_for' do
      before { view.stub(:content_for).with(:title).and_return 'content-title' }

      xit 'returns it dynamic value' do
        helper.title.should == 'Washington Botelho | content-title'
      end
    end
  end

  describe '#donate_button' do
    let!(:item_name) { 'wbotelhos\.com' }
    let!(:href) { %r(href="https://www\.paypal\.com/cgi-bin/webscr\?cmd=_donations&amp;business=X8HEP2878NDEG&amp;item_name=#{item_name}") }

    context 'without item_name parameter' do
      it 'buils the html' do
        helper.donate_button.should match %r(href="https://www\.paypal.com/cgi-bin/webscr\?cmd=_donations&amp;business=X8HEP2878NDEG&amp;item_name=#{item_name})
        helper.donate_button.should match 'id="donate"'
        helper.donate_button.should match '<i class="icon-heart-empty"></i>Donate'
      end
    end

    context 'with item_name parameter' do
      let!(:item_name) { 'some_item_name' }

      it 'buils the html' do
        helper.donate_button(item_name).should match %r(href="https://www\.paypal.com/cgi-bin/webscr\?cmd=_donations&amp;business=X8HEP2878NDEG&amp;item_name=#{item_name})
        helper.donate_button(item_name).should match 'id="donate"'
        helper.donate_button(item_name).should match '<i class="icon-heart-empty"></i>Donate'
      end
    end
  end
end
