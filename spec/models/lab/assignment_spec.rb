require "spec_helper"

describe Lab, "assignment" do

  subject {
    Lab.new({ :name => "name", :slug => "slug", :description => "description" })
  }

  its(:name) { should eql("name") }
  its(:slug) { should eql("slug") }
  its(:description) { should eql("description") }

end
