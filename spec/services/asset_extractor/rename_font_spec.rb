# frozen_string_literal: true

RSpec.describe AssetExtractor, '#rename_font' do
  subject(:extractor) { described_class.new(media, content, 'http://0.0.0.0:3000') }

  let!(:content) do
    <<~HEREDOC
      @font-face {
        font-family: 'blogy';
        font-style: normal;
        font-weight: normal;
        src: url(/assets/blogy-39127bf9cb97.eot);
        src: url(/assets/blogy-39127bf9cb97.eot?#iefix) format("embedded-opentype");
        src: url(/assets/blogy-b6c126b411f8.svg#blogy) format("svg");
        src: url(/assets/blogy-c38d97f2100a.ttf) format("truetype");
        src: url(/assets/blogy-0c2198340a83.woff) format("woff");
      }
    HEREDOC
  end
  let!(:media) { Lab.new }

  it 'replaces the path' do
    expect(extractor.rename_font(content)).to eq <<~HEREDOC
      @font-face {
        font-family: 'blogy';
        font-style: normal;
        font-weight: normal;
        src: url(../fonts/blogy.eot);
        src: url(../fonts/blogy.eot?#iefix) format("embedded-opentype");
        src: url(../fonts/blogy.svg#blogy) format("svg");
        src: url(../fonts/blogy.ttf) format("truetype");
        src: url(../fonts/blogy.woff) format("woff");
      }
    HEREDOC
  end
end
