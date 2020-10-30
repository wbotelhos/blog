# frozen_string_literal: true

RSpec.describe Article, '.generate_slug' do
  let!(:article) { FactoryBot.create(:article, title: 'Some Title') }

  context 'when is save' do
    it 'slug the title' do
      expect(article.slug).to eq 'some-title'
    end
  end

  context 'when is update' do
    it 'slug the title' do
      article.update!(title: 'New Title')

      expect(article.slug).to eq 'new-title'
    end
  end
end
