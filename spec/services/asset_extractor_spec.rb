require 'spec_helper'

describe AssetExtractor::Url, :focus do
  let(:base_url) { 'http://example.org' }

  describe '.to_s' do
    context 'with urls starting with http' do
      let(:url) { 'http://example.org' }

      it 'returns the self url' do
        expect(described_class.new(base_url, url).to_s).to eq url
      end
    end

    context 'with urls starting with https' do
      let(:url) { 'https://example.org' }

      it 'returns the self url' do
        expect(described_class.new(base_url, url).to_s).to eq url
      end
    end

    context 'with urls starting with //' do
      let(:url) { '//example.org' }

      it 'returns the self url appended with http:' do
        expect(described_class.new(base_url, url).to_s).to eq "http:#{url}"
      end
    end

    context 'with urls not starting with http, https or //' do
      let(:url) { '/example.org' }

      it 'returns the self url appended with base_url' do
        expect(described_class.new(base_url, url).to_s).to eq "#{base_url}#{url}"
      end
    end

  end
end
