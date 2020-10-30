# frozen_string_literal: true

RSpec.describe CommentsController, '#create' do
  let!(:parameters) do
    {
      body:  'body',
      email: 'example@example.com',
      name:  'name',
      url:   'https://www.example.com',
    }
  end

  context 'when commentable is article' do
    let!(:commentable) { FactoryBot.create(:article) }

    it 'reassings decorated article' do
      post :create, params: { comment: parameters, article_id: commentable.id }

      record = assigns(:media)

      expect(record).to       eq commentable
      expect(record.class).to eq ArticlePresenter
    end
  end

  context 'when commentable is lab' do
    let!(:commentable) { FactoryBot.create(:lab) }

    it 'reassings decorated lab' do
      post :create, params: { comment: parameters, lab_id: commentable.id }

      record = assigns(:media)

      expect(record).to       eq commentable
      expect(record.class).to eq LabPresenter
    end
  end
end
