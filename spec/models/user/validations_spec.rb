require 'spec_helper'

describe User, "validations" do
  it { should_not allow(nil).for(:name) }
  it { should_not allow("invalid", nil).for(:email) }
  it { should_not allow(nil).for(:password) }

  it { should allow("name").for(:name) }
  it { should allow("email@email.com").for(:email) }
  it { should allow("password").for(:password) }
  it { should allow("bio").for(:bio) }
  it { should allow("github").for(:github) }
  it { should allow("linkedin").for(:linkedin) }
  it { should allow("twitter").for(:twitter) }
  it { should allow("facebook").for(:facebook) }
  it { should allow("password").for(:password) }
  it { should allow("password").for(:password_confirmation) }

  context "e-mail uniqueness" do
    let(:user) {
      User.create!({
        name: "name",
        email: "email@email.com",
        password: "password",
        :password_confirmation => "password"
        })
    }

    it { should_not allow(user.email).for(:email) }
  end

  context "confirming password" do
    it "has a invalid one" do
      User.new({
        name: "name",
        email: "email@email.com",
        password: "password",
        :password_confirmation => "password_invalid"
      }).should_not be_valid
    end
  end
end
