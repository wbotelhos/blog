require 'spec_helper'

describe Article, "assignment" do
  let(:category) { FactoryGirl.create :category }

  subject do
    Article.new(
      title: 'title',
      body: 'body',
      slug: 'slug',
      category_ids: [category.id]
    )
  end

  its(:title) { should == 'title' }
  its(:body) { should == 'body' }
  its(:slug) { should == 'slug' }
  its(:category_ids) { should == [category.id] }
end
