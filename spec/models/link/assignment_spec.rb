require 'spec_helper'

describe Link, "assignment" do
  subject { Link.new name: 'name', url: 'http://url.com' }

  its(:name) { should == 'name' }
  its(:url) { should == 'http://url.com' }
end
