# frozen_string_literal: true

RSpec.describe AssetExtractor, '#rename_js' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) { '<script src="/assets/labs.debug-b8b2a61.js"></script>' }
  let!(:media) { Lab.new }

  it 'replaces the host' do
    expect(extractor.rename_js(content)).to eq('<script src="javascripts/labs.js"></script>')
  end
end
