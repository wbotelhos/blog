# frozen_string_literal: true

RSpec.describe AssetExtractor, '#rename_favicon' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) { '<link rel="shortcut icon" type="image/x-icon" href="/assets/favicon-2fd0d771aae7.ico">' }
  let!(:media) { Lab.new }

  it 'replaces the host' do
    expect(extractor.rename_favicon(content)).to eq '<link rel="shortcut icon" type="image/x-icon" href="favicon.ico">'
  end
end
