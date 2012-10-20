require 'spec_helper'

describe User, "assignment" do
  subject do
    User.new(
      name: 'name',
      email: 'mail@mail.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  its(:name) { should == 'name' }
  its(:email) { should == 'mail@mail.com' }
  its(:password) { should == 'password' }
  its(:password_confirmation) { should == 'password' }
end
