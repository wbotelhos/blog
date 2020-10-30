# frozen_string_literal: true

RSpec.describe Article, '.published' do
  let!(:article_draft) { FactoryBot.create :article }

  context 'article without published date on the past' do
    let!(:article_1) { FactoryBot.create :article, published_at: Time.zone.local(2013, 0o1, 0o1) }
    let!(:article_2) { FactoryBot.create :article, published_at: Time.zone.local(2013, 0o1, 0o1) }

    it 'is ignored' do
      expect(described_class.published).to include article_1, article_2
    end
  end

  context 'article without published date in the same time' do
    before do
      allow(Time).to receive(:now).and_return Time.zone.local(2013, 1, 1, 0, 0, 0)

      @article_now = FactoryBot.create :article, published_at: Time.current
    end

    it 'is ignored' do
      expect(described_class.published).to include @article_now
    end
  end

  context 'article without published date' do
    it 'is ignored' do
      expect(described_class.published).not_to include article_draft
    end
  end

  context 'article with published date but in the future (scheduled)' do
    let!(:article_scheduled) { FactoryBot.create :article, published_at: Time.zone.local(2500, 1, 1) }

    it 'is ignored' do
      expect(described_class.published).not_to include article_scheduled
    end
  end
end
