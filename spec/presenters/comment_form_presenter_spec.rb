require "spec_helper"

describe CommentFormPresenter do
  let(:article) { mock("article") }
  let(:comment) { mock("comment") }

  context "show form" do
    subject {
      CommentFormPresenter.new(article, comment)
    }

    its(:partial) {
      should eql(:partial => "comments/form", :locals => { :article => article, :comment => comment })
    }
  end
end
