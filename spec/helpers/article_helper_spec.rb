# frozen_string_literal: true

RSpec.describe ArticleHelper do
  describe '#published_at' do
    context 'with published_at date' do
      let(:article) { FactoryBot.build :article, published_at: Time.zone.local(2000) }

      it 'returns the published date formated' do
        expect(helper.published_at(article)).to eq '01 de Janeiro de 2000'
      end
    end

    context 'without published_at date' do
      let(:article) { FactoryBot.build :article, created_at: Time.zone.local(2001) }

      it 'returns the created date formated' do
        expect(helper.published_at(article)).to eq '01 de Janeiro de 2001'
      end
    end
  end
end
