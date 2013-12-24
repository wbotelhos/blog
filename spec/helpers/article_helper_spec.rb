require 'spec_helper'

describe ArticleHelper do
  describe '#published_at' do
    context 'with published_at date' do
      let(:article) { FactoryGirl.build :article, published_at: Time.local(2000, 1, 1) }

      it 'returns the published date formated' do
        expect(helper.published_at article).to eq '01 de Janeiro de 2000'
      end
    end

    context 'without published_at date' do
      let(:article) { FactoryGirl.build :article, created_at: Time.local(2001, 1, 1) }

      it 'returns the created date formated' do
        expect(helper.published_at article).to eq '01 de Janeiro de 2001'
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
