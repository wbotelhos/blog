require 'spec_helper'

describe Lab, "assignment" do
  subject do
    Lab.new(
      name: 'name',
      slug: 'slug',
      description: 'description',
      image: 'image.png'
    )
  end

  its(:name) { should == 'name' }
  its(:slug) { should == 'slug' }
  its(:description) { should == 'description' }
  its(:image) { should == 'image.png' }
end
