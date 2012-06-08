require "spec_helper"

describe User, "assignment" do

  subject {
    User.new({
      :name => "Washington Botelho",
      :email => "wbotelhos@gmail.com",
      :password => "test",
      :password_confirmation => "test"
    })
  }

  its(:name) { should eql("Washington Botelho") }
  its(:email) { should eql("wbotelhos@gmail.com") }
  its(:password) { should eql("test") }
  its(:password_confirmation) { should eql("test") }

end
