require "spec_helper"

describe Link, "assignment" do

  subject {
    Link.new({
      :name => "name",
      :url => "http://url.com"
    })
  }

  its(:name) { should eql("name") }
  its(:url) { should eql("http://url.com") }

end
