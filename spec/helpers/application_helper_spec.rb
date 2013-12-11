require 'spec_helper'
require 'digest/md5'

describe ApplicationHelper do
  describe '#gravatar' do
    let(:email) { 'wbotelhos@gmail.com' }
    let(:md5)   { Digest::MD5.hexdigest email }

    context 'without :size' do
      it 'build an image' do
        expect(helper.gravatar email).to match %r(src="http://www\.gravatar\.com/avatar/#{md5}\?d=mm")
      end
    end

    context 'without alt parameter' do
      it 'builds the html with empty alt' do
        expect(helper.gravatar email).to match 'alt=""'
      end
    end

    context 'with alt parameter' do
      it 'builds the html with alt' do
        expect(helper.gravatar(email, alt: :alt)).to match 'alt="alt"'
      end
    end
  end

  describe '#donate_button' do
    let(:item_name) { 'wbotelhos\.com' }

    context 'without item_name parameter' do
      it 'builds the html' do
        expect(helper.donate_button).to match %r(https://www\.paypal.com/cgi-bin/webscr\?cmd=_donations&amp;business=X8HEP2878NDEG&amp;item_name=#{item_name})
      end
    end

    context 'with item_name parameter' do
      let(:item_name) { 'some_item_name' }

      it 'builds the html' do
        expect(helper.donate_button item_name).to match %r(https://www\.paypal.com/cgi-bin/webscr\?cmd=_donations&amp;business=X8HEP2878NDEG&amp;item_name=#{item_name})
      end
    end
  end
end
