# frozen_string_literal: true

RSpec.describe AssetExtractor, '#rename_plugin' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) { '<script src="slug/lib/jquery.slug.js"></script>' }
  let!(:media) { Lab.new(slug: 'slug') }

  it 'replaces the path' do
    expect(extractor.rename_plugin(content)).to eq('<script src="../lib/jquery.slug.js"></script>')
  end
end
