# frozen_string_literal: true

RSpec.describe PageExtractorService, '#files_for_extraction' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) do
    %(
      <link rel="stylesheet" media="screen" href="/assets/labs.debug-f20ed2ac2dc.css" />
      <script src="/assets/labs.debug-b8b2a6dfbc.js"></script>
    )
  end

  let!(:media) { Lab.new(slug: 'slug') }
  let!(:selector) { 'link[href*="labs"], script[src*="labs"]' }

  it 'returns the file url the filename and the file target' do
    result = extractor.files_for_extraction(selector)

    expect(result[0][:filename]).to    eq('labs.css')
    expect(result[0][:folder]).to      eq('stylesheets')
    expect(result[0][:target].to_s).to match('/blogy/public/slug/demo/stylesheets/labs.css')
    expect(result[0][:url]).to         eq('http://0.0.0.0:3000/assets/labs.debug-f20ed2ac2dc.css')
  end
end
