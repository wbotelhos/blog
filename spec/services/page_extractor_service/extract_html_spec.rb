# frozen_string_literal: true

RSpec.describe PageExtractorService, '#extract_html' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) do
    <<~HEREDOC
      <!DOCTYPE html>
      <html>
      <head>
      <link rel="shortcut icon" type="image/x-icon" href="/assets/favicon-2fd0d771aae7.ico">

      <link rel="stylesheet" media="screen" href="/assets/labs.debug-f20ed2ac2dc.css" />

      <script src="/assets/labs.debug-b8b2a61.js"></script>
      <script src="raty/node_modules/jquery/dist/jquery.min.js"></script><script src="slug/lib/jquery.slug.js"></script>
      </head>
      <body>
      <a class="media__edit" href="/labs/1/edit">Editar</a>

      $('#starHalf').raty({
        half:     true,
        path:     null,
        starHalf: 'raty/lib/images/star-half-mono.jpg',
        starOff:  'raty/lib/images/star-off.jpeg',
        starOn:   'raty/lib/images/star-on.png'
      });
      </body>
      </html>
    HEREDOC
  end

  let!(:media) { Lab.new(slug: 'slug') }

  before { FileUtils.rm_rf('public/slug/demo') }

  it 'extracts an offline page' do
    extractor.extract_html

    expect(File.open('public/slug/demo/index.html').read).to eq <<~HEREDOC
      <!DOCTYPE html>
      <html>
      <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <link rel="shortcut icon" type="image/x-icon" href="favicon.ico">

      <link rel="stylesheet" media="screen" href="stylesheets/labs.css">

      <script src="javascripts/labs.js"></script>
      <script src="../node_modules/jquery/dist/jquery.min.js"></script><script src="../lib/jquery.slug.js"></script>
      </head>
      <body>


      $('#starHalf').raty({
        half:     true,
        path:     null,
        starHalf: 'images/star-half-mono.jpg',
        starOff:  'images/star-off.jpeg',
        starOn:   'images/star-on.png'
      });
      </body>
      </html>
    HEREDOC
  end
end
