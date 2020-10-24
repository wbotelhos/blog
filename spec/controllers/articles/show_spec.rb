# frozen_string_literal: true

RSpec.describe ArticlesController, '#show' do
  let!(:article) { FactoryBot.create(:article) }

  it 'assigns article represented' do
    get :show, params: { slug: article.slug }

    record = assigns(:media)

    expect(record).to eq article
    expect(record.class).to eq ArticlePresenter
  end

  it 'assigns root comments represented ordered by created at desc' do
    comment_1 = FactoryBot.create(:comment, commentable: article)
    comment_2 = FactoryBot.create(:comment, commentable: article)

    # ignored: not root comment
    FactoryBot.create(:comment, commentable: article, parent: comment_2)

    get :show, params: { slug: article.slug }

    records = assigns(:root_comments)

    expect(records.size).to eq 2

    expect(records[0]).to       eq comment_2
    expect(records[0].class).to eq CommentPresenter

    expect(records[1]).to       eq comment_1
    expect(records[1].class).to eq CommentPresenter
  end
end
