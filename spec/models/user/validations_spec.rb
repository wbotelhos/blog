require "spec_helper"

describe User, "validations" do
  it { should_not allow(nil).for(:name) }
  it { should_not allow("invalid", nil).for(:email) }
  it { should_not allow(nil).for(:password) }

  it { should allow("Washington Botelho").for(:name) }
  it { should allow("wbotelhos@gmail.com").for(:email) }
  it { should allow("test").for(:password) }
  it { should allow("bio").for(:bio) }
  it { should allow("github").for(:github) }
  it { should allow("linkedin").for(:linkedin) }
  it { should allow("twitter").for(:twitter) }
  it { should allow("facebook").for(:facebook) }

  context "e-mail uniqueness" do
    let!(:user) {
      User.create!({
        :name => "Washington Botelho",
        :email => "wbotelhos@gmail.com",
        :password => "test",
        :password_confirmation => "test"
        })
    }

    it { should_not allow(user.email).for(:email) }
  end
end
