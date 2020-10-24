# frozen_string_literal: true

RSpec.describe CommentPresenter, '#content' do
  let!(:comment) { FactoryBot.create(:comment, body: 'body') }

  before { allow(HighlighterService).to receive(:highlight).with('body').and_return('content') }

  it 'receives text processed by Highlighter service' do
    expect(described_class.new(comment).content).to eq('content')
  end
end
