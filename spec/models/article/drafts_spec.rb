# frozen_string_literal: true

RSpec.describe Article, '.drafts' do
  let!(:article_draft) { FactoryBot.create :article }

  it 'returns drafts' do
    expect(described_class.drafts).to eq [article_draft]
  end
end
