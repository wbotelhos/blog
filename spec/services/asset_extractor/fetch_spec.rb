# frozen_string_literal: true

RSpec.describe AssetExtractor, '#fetch' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) { '<html></html>' }
  let!(:media) { Lab.new(slug: 'slug') }

  it 'fetchs the data forcing encode to binary' do
    body     = instance_double('String', force_encoding: 'encoded_body')
    response = OpenStruct.new(body: body)

    allow(Aitch).to receive(:get).with('url').and_return(response)

    expect(extractor.fetch('url')).to eq('encoded_body')

    expect(body).to have_received(:force_encoding).with('binary')
  end
end
