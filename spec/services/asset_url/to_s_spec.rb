# frozen_string_literal: true

RSpec.describe AssetUrl, '#to_s' do
  subject(:asset_url) { described_class.new('http://0.0.0.0:3000', url) }

  context 'when url starts with http' do
    let(:url) { 'http://www.example.com' }

    it 'returns the self url' do
      expect(asset_url.to_s).to eq 'http://www.example.com'
    end
  end

  context 'when url starts with https' do
    let(:url) { 'https://www.example.com' }

    it 'returns the self url' do
      expect(asset_url.to_s).to eq 'https://www.example.com'
    end
  end

  context 'when url starts with //' do
    let(:url) { '//www.example.com' }

    it 'returns the self url starting with http' do
      expect(asset_url.to_s).to eq 'http://www.example.com'
    end
  end

  context 'when url does not starts with http or https nor //' do
    let(:url) { 'favico.ico' }

    it 'returns the self url starting with http' do
      expect(asset_url.to_s).to eq 'http://0.0.0.0:3000/favico.ico'
    end
  end
end
