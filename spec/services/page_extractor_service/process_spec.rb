# frozen_string_literal: true

RSpec.describe PageExtractorService, '#process' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) do
    <<~HEREDOC
      <link rel="shortcut icon" type="image/x-icon" href="/assets/favicon-2fd0d771aae7.ico">

      <link rel="stylesheet" media="screen" href="/assets/labs.debug-f20ed2ac2dc.css" />

      <script src="/assets/labs.debug-b8b2a61.js"></script>
      <script src="slug/lib/jquery.slug.js"></script>

      $('#starHalf').raty({
        half:     true,
        path:     null,
        starHalf: 'raty/lib/images/star-half-mono.jpg',
        starOff:  'raty/lib/images/star-off.jpeg',
        starOn:   'raty/lib/images/star-on.png'
      });
    HEREDOC
  end

  let!(:media) { Lab.new(slug: 'slug') }

  it 'calls extract html and labs css and js' do
    allow(extractor).to receive(:extract_html)
    allow(extractor).to receive(:write_file).twice

    extractor.process

    target_css = Rails.root.join('public/slug/demo/stylesheets/labs.css')
    source_css = extractor.rename_font(Rails.application.assets['labs.css'].source)

    target_js = Rails.root.join('public/slug/demo/javascripts/labs.js')
    source_js = Rails.application.assets['labs.js'].source

    expect(extractor).to have_received(:write_file).with(target_css, source_css)
    expect(extractor).to have_received(:write_file).with(target_js, source_js)

    expect(extractor).to have_received(:extract_html)
  end
end
