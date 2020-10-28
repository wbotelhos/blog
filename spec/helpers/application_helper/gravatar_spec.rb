# frozen_string_literal: true

require 'digest/md5'
require 'support/env_mock'

RSpec.describe ApplicationHelper, '#gravatar' do
  let(:email) { 'wbotelhos@example.com' }

  context 'into production env' do
    let(:md5) { Digest::MD5.hexdigest(email) }

    context 'with :size' do
      it 'build an image with size' do
        EnvMock.mock(RAILS_ENV: 'production') do
          expect(helper.gravatar(email, size: 1)).to match %r(src="https://www\.gravatar\.com/avatar/#{md5}\?d=mm&amp;s=1")
        end
      end
    end

    context 'without :size' do
      it 'build an image' do
        EnvMock.mock(RAILS_ENV: 'production') do
          expect(helper.gravatar(email)).to match %r(src="https://www\.gravatar\.com/avatar/#{md5}\?d=mm")
        end
      end
    end
  end

  context 'outside production env' do
    it 'build default image url' do
      EnvMock.mock(RAILS_ENV: 'test') do
        expect(helper.gravatar(email)).to match %r(src="/assets/avatar.jpg")
      end
    end
  end

  context 'without alt parameter' do
    it 'builds the html with empty alt' do
      EnvMock.mock(RAILS_ENV: 'test') do
        expect(helper.gravatar(email)).to match 'alt=""'
      end
    end
  end

  context 'with alt parameter' do
    it 'builds the html with alt' do
      EnvMock.mock(RAILS_ENV: 'test') do
        expect(helper.gravatar(email, alt: :alt)).to match 'alt="alt"'
      end
    end
  end
end
