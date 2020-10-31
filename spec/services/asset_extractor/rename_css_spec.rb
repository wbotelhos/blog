# frozen_string_literal: true

RSpec.describe AssetExtractor, '#rename_css' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) { '<link rel="stylesheet" media="screen" href="/assets/labs.debug-f20ed2ac2d20c93.css" />' }
  let!(:media) { Lab.new }

  it 'replaces the host' do
    expect(extractor.rename_css(content)).to eq('<link rel="stylesheet" media="screen" href="stylesheets/labs.css" />')
  end
end
