require "spec_helper"

describe Article, "assignment" do
  let!(:category) { FactoryGirl.create(:category) }

  subject {
    Article.new({
      :title => "title",
      :body => "body",
      :category_ids => [category.id]
    })
  }

  its(:title) { should eql("title") }
  its(:body) { should eql("body") }

end
