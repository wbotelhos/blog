require "spec_helper"

describe User, "assignment" do
  subject {
    User.new({
      :name => "name",
      :email => "email@email.com",
      :password => "password",
      :password_confirmation => "password"
    })
  }

  its(:name) { should eql("name") }
  its(:email) { should eql("email@email.com") }
  its(:password) { should eql("password") }
  its(:password_confirmation) { should eql("password") }
end
