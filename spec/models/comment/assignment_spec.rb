require "spec_helper"

describe Comment, "assignment" do
  subject {
    Comment.new({
      :name => "name",
      :email => "email@email.com",
      :body => "body",
      :article_id => 1,
      :comment_id => 1
    })
  }

  its(:name) { should eql("name") }
  its(:email) { should eql("email@email.com") }
  its(:body) { should eql("body") }
  its(:article_id) { should eql(1) }
  its(:comment_id) { should eql(1) }
end
