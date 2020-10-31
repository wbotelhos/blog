# frozen_string_literal: true

RSpec.describe PageExtractorService, '#rename_plugin' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) do
    <<~HEREDOC
      <link rel="stylesheet" href="slug/lib/jquery.slug.css">
      <script src="slug/node_modules/jquery/dist/jquery.min.js"></script><script src="slug/lib/jquery.slug.js"></script>
    HEREDOC
  end

  let!(:media) { Lab.new(slug: 'slug') }

  it 'replaces the path' do
    expect(extractor.rename_plugin(content)).to eq <<~HEREDOC
      <link rel="stylesheet" href="../lib/jquery.slug.css">
      <script src="slug/node_modules/jquery/dist/jquery.min.js"></script><script src="../lib/jquery.slug.js"></script>
    HEREDOC
  end
end
