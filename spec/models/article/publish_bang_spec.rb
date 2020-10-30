# frozen_string_literal: true

RSpec.describe Article do
  let!(:article) { FactoryBot.create :article }

  it 'begins unpublished' do
    expect(article.published_at).to be_nil
  end

  context 'when publish' do
    before { article.publish! }

    it 'becames published' do
      expect(article.published_at).not_to be_nil
    end
  end
end
