require 'spec_helper'

describe Comment, "assignment" do
  subject do
    Comment.new(
      name: 'name',
      email: 'mail@mail.com',
      body: 'body',
      article_id: 1,
      comment_id: 1
    )
  end

  its(:name) { should == 'name' }
  its(:email) { should == 'mail@mail.com' }
  its(:body) { should == 'body' }
  its(:article_id) { should eql 1 }
  its(:comment_id) { should eql 1 }
end
