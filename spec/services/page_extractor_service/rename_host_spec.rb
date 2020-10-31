# frozen_string_literal: true

RSpec.describe PageExtractorService, '#rename_host' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) { '<a href="http://0.0.0.0:3000/slug">Title</a>' }
  let!(:media) { Lab.new }

  it 'replaces the host' do
    expect(extractor.rename_host(content)).to eq '<a href="https://www.wbotelhos.com/slug">Title</a>'
  end
end
