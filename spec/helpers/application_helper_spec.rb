require 'spec_helper'
require 'digest/md5'

describe ApplicationHelper do
  describe '#gravatar' do
    let(:email) { 'wbotelhos@gmail.com' }
    let(:md5)   { Digest::MD5.hexdigest email }

    context 'into production env' do
      before { Rails.env = 'production' }

      context 'with :size' do
        it 'build an image with size' do
          expect(helper.gravatar email, size: 1).to match %r(src="http://www\.gravatar\.com/avatar/#{md5}\?d=mm&amp;s=1")
        end
      end

      context 'without :size' do
        it 'build an image' do
          expect(helper.gravatar email).to match %r(src="http://www\.gravatar\.com/avatar/#{md5}\?d=mm")
        end
      end
    end

    context 'outside production env' do
      before { Rails.env = 'test' }

      it 'build default image url' do
        expect(helper.gravatar email).to match %r(src="/assets/avatar.jpg")
      end
    end

    context 'without alt parameter' do
      it 'builds the html with empty alt' do
        expect(helper.gravatar email).to match 'alt=""'
      end
    end

    context 'with alt parameter' do
      it 'builds the html with alt' do
        expect(helper.gravatar email, alt: :alt).to match 'alt="alt"'
      end
    end
  end

  describe '#media_slug' do
    let(:article) { FactoryGirl.create :article, title: 'Some Title' }

    context 'without anchor' do
      it 'builds the path without anchor' do
        expect(helper.media_slug article).to eq '/some-title'
      end
    end

    context 'with anchor' do
      it 'builds the path with anchor' do
        expect(helper.media_slug article, 'anchor').to eq '/some-title#anchor'
      end
    end
  end

  describe '#media_slug_url' do
    let(:article) { FactoryGirl.create :article, title: 'Some Title' }

    before { @request.host = 'example.org' }

    context 'without anchor' do
      it 'builds the path without anchor' do
        expect(helper.media_slug_url article).to eq 'http://example.org/some-title'
      end
    end

    context 'with anchor' do
      it 'builds the path with anchor' do
        expect(helper.media_slug_url article, 'anchor').to eq 'http://example.org/some-title#anchor'
      end
    end
  end

  describe '#twitter_button' do
    context '' do
      let(:button) { CGI.unescape helper.twitter_button(text: 'Some Text', url: 'http://wbotelhos.com') }

      it 'builds the right text' do
        expect(button).to match %r(text="Some Text" ~)
      end

      it 'builds the right url' do
        expect(button).to match %r(url=http://wbotelhos.com)
      end

      it 'builds the right via' do
        expect(button).to match %r(via=wbotelhos)
      end

      it 'builds the right target' do
        expect(button).to match %r(target="_blank")
      end
    end
  end
end
