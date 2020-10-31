# frozen_string_literal: true

RSpec.describe AssetExtractor, '#filename_extension' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) { '<html></html>' }
  let!(:media) { Lab.new }

  it 'returns the filename and extension' do
    expect(extractor.filename_extension('/assets/labs-f20ed2.css')).to                         eq ['labs.css', '.css']
    expect(extractor.filename_extension('/assets/labs.debug-f20ed2.js')).to                    eq ['labs.js', '.js']
    expect(extractor.filename_extension('http://www.wbotelhos.com/assets/labs-f20ed2.png')).to eq ['labs.png', '.png']
  end
end
