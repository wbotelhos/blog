# frozen_string_literal: true

RSpec.describe AssetExtractor, '#join_paths' do
  subject(:extractor) { described_class.new(media, html, 'http://0.0.0.0:3000') }

  let!(:html) { '<html></html>' }
  let!(:media) { FactoryBot.create(:article, title: 'title') }

  context 'when more than one argument is given' do
    it 'build the path to the public folder' do
      expect(extractor.join_paths('a', 'b').to_s).to match('/blogy/public/title/a/b')
    end
  end

  context 'when one argument is given' do
    it 'build the path to the public folder' do
      expect(extractor.join_paths('a').to_s).to match('/blogy/public/title/a')
    end
  end

  context 'when an array of arguments is given' do
    it 'build the path to the public folder' do
      expect(extractor.join_paths(%w[a b]).to_s).to match('/blogy/public/title/a/b')
    end
  end
end
