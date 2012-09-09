require "spec_helper"

describe Article, "assignment" do
  let!(:category) { FactoryGirl.create(:category) }

  subject {
    Article.new({
      :title => "title",
      :body => "body",
      :slug => "slug",
      :category_ids => [category.id]
    })
  }

  its(:title) { should eql("title") }
  its(:body) { should eql("body") }
  its(:slug) { should eql("slug") }
  its(:category_ids) { should eql([category.id]) }
end
