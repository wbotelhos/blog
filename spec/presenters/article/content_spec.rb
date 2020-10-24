# frozen_string_literal: true

RSpec.describe ArticlePresenter, '#content' do
  let!(:article) { FactoryBot.create(:article, body: 'body') }

  before { allow(HighlighterService).to receive(:highlight).with('body').and_return('content') }

  it 'receives text processed by Highlighter service' do
    expect(described_class.new(article).content).to eq('content')
  end
end
