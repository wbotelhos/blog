# frozen_string_literal: true

RSpec.describe ArticlePresenter, '.wrap' do
  let!(:article_1) { FactoryBot.build(:article) }
  let!(:article_2) { FactoryBot.build(:article) }

  it 'converts each article into presenter' do
    articles = described_class.wrap([article_1, article_2])

    expect(articles.size).to eq 2

    expect(articles[0]).to eq article_1
    expect(articles[0].class).to eq described_class

    expect(articles[1]).to eq article_2
    expect(articles[1].class).to eq described_class
  end
end
