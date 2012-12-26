require 'spec_helper'

describe CommentsController do
  context 'create comment' do
    let(:article) { mock_model(Article) }
    let(:comment) { Comment.new }

    before do
      Article.stub find: article
      controller.stub_chain(:article, :comments, new: comment)
      comment.stub save: true
    end

    xit 'redirects to the article page' do
      post :create, article_id: article.id
      response.should redirect_to article_path(article.id)
    end
  end
end
