# frozen_string_literal: true

RSpec.describe PageExtractorService, '#rename_image' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) do
    <<~HEREDOC
      $('#starHalf').raty({
        half:     true,
        path:     null,
        starHalf: 'raty/lib/images/star-half-mono.jpg',
        starOff:  'raty/lib/images/star-off.jpeg',
        starOn:   'raty/lib/images/star-on.png'
      });
    HEREDOC
  end

  let!(:media) { Lab.new }

  it 'replaces the host' do
    expect(extractor.rename_image(content)).to eq <<~HEREDOC
      $('#starHalf').raty({
        half:     true,
        path:     null,
        starHalf: 'images/star-half-mono.jpg',
        starOff:  'images/star-off.jpeg',
        starOn:   'images/star-on.png'
      });
    HEREDOC
  end
end
