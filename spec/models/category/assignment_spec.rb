require 'spec_helper'

describe Category, "assignment" do
  subject { Category.new name: 'name' }

  its(:name) { should == 'name' }
end
