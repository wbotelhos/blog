# frozen_string_literal: true

RSpec.describe ArticlesController, '#show' do
  let!(:article) { FactoryBot.create(:article) }

  it 'assigns article represented' do
    get :show, params: { slug: article.slug }

    record = assigns(:article)

    expect(record).to eq article
    expect(record.class).to eq ArticlePresenter
  end
end
