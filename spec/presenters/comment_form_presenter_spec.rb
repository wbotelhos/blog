require 'spec_helper'

describe CommentFormPresenter do
  let(:article) { mock_model Article }
  let(:comment) { mock_model Comment }

  subject { CommentFormPresenter.new(article, comment) }

  context "showing form" do
    its(:partial) { should eql(partial: 'comments/form', locals: { article: article, comment: comment }) }
  end
end
