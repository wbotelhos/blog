# frozen_string_literal: true

RSpec.describe LabPresenter, '#content' do
  let!(:lab) { FactoryBot.create(:lab, body: 'body') }

  before { allow(HighlighterService).to receive(:highlight).with('body').and_return('content') }

  it 'receives text processed by Highlighter service' do
    expect(described_class.new(lab).content).to eq('content')
  end
end
