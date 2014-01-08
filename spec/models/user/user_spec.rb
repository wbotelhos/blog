require 'spec_helper'

describe User do
  it 'has a valid factory' do
    expect(FactoryGirl.build :user).to be_valid
  end

  it { should validate_presence_of :email }

  context :create do
    it 'creates a valid media' do
      expect(User.new(
        email:                 'john@example.org',
        password:              'password',
        password_confirmation: 'password'
      )).to be_valid
    end
  end

  context :format do
    it 'validates the email format' do
      expect(FactoryGirl.build(:user, email: 'fail')).to be_invalid
      expect(FactoryGirl.build(:user, email: 'fail@')).to be_invalid
      expect(FactoryGirl.build(:user, email: 'fail@fail')).to be_invalid
      expect(FactoryGirl.build(:user, email: 'fail@fail.')).to be_invalid

      expect(FactoryGirl.build(:user, email: 'ok@ok.ok')).to be_valid
    end
  end

  context :uniqueness do
    let(:user) { FactoryGirl.create :user }

    it 'does not allow the same email'  do
      expect(FactoryGirl.build(:user, email: user.email)).to be_invalid
    end
  end

  context :confirmation do
    it 'has a invalid one' do
      expect(User.new(
        email:                 'john@example.org',
        password:              'password',
        password_confirmation: 'password_wrong'
      )).to_not be_valid
    end
  end
end
