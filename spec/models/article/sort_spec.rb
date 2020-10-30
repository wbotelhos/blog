# frozen_string_literal: true

RSpec.describe Article, '.sort' do
  let!(:article_1) { FactoryBot.create(:article, published_at: Time.zone.local(2013, 3)) }
  let!(:article_2) { FactoryBot.create(:article, published_at: Time.zone.local(2013, 2)) }
  let!(:article_3) { FactoryBot.create(:article, published_at: Time.zone.local(2013, 1)) }

  context 'when is by created' do
    it 'sort by created_at desc' do
      expect(described_class.by_created).to eq [article_3, article_2, article_1]
    end
  end

  context 'when is by published' do
    it 'sort by published_at desc' do
      expect(described_class.by_published).to eq [article_1, article_2, article_3]
    end
  end
end
