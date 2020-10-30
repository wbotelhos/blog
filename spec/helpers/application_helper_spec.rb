# frozen_string_literal: true

require 'digest/md5'

RSpec.describe ApplicationHelper do
  describe '#media_slug' do
    let(:article) { FactoryBot.create :article, title: 'Some Title' }

    context 'without anchor' do
      it 'builds the path without anchor' do
        expect(helper.media_slug(article)).to eq '/some-title'
      end
    end

    context 'with anchor' do
      it 'builds the path with anchor' do
        expect(helper.media_slug(article, 'anchor')).to eq '/some-title#anchor'
      end
    end
  end

  describe '#media_slug_url' do
    let(:article) { FactoryBot.create :article, title: 'Some Title' }

    before { @request.host = 'example.org' }

    context 'without anchor' do
      it 'builds the path without anchor' do
        expect(helper.media_slug_url(article)).to eq 'http://example.org/some-title'
      end
    end

    context 'with anchor' do
      it 'builds the path with anchor' do
        expect(helper.media_slug_url(article, 'anchor')).to eq 'http://example.org/some-title#anchor'
      end
    end
  end

  describe '#twitter_button' do
    let(:button) { CGI.unescape helper.twitter_button(text: 'Some Text', url: 'https://www.wbotelhos.com') }

    it 'builds the right text' do
      expect(button).to match(/text="Some Text"/)
    end

    it 'builds the right url' do
      expect(button).to match %r(url=https://www.wbotelhos.com)
    end

    it 'builds the right via' do
      expect(button).to match(/via=#{CONFIG['twitter']}/)
    end

    it 'builds the right target' do
      expect(button).to match(/target="_blank"/)
    end
  end
end
