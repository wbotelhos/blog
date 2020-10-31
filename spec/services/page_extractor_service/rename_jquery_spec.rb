# frozen_string_literal: true

RSpec.describe PageExtractorService, '#rename_jquery' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:media) { Lab.new }

  context 'when path is local' do
    let!(:content) { '<script src="raty/node_modules/jquery/dist/jquery.min.js"></script>' }

    it 'replaces the path' do
      expect(extractor.rename_jquery(content)).to eq('<script src="../node_modules/jquery/dist/jquery.min.js"></script>')
    end
  end

  context 'when path is cdn' do
    let!(:content) { '<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>' }

    it 'replaces the host' do
      expect(extractor.rename_jquery(content)).to eq('<script src="../node_modules/jquery/dist/jquery.min.js"></script>')
    end
  end

  context 'when path is cdn not minified' do
    let!(:content) { '<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.js"></script>' }

    it 'replaces the host to minified file' do
      expect(extractor.rename_jquery(content)).to eq('<script src="../node_modules/jquery/dist/jquery.min.js"></script>')
    end
  end
end
