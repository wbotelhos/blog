# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe User do
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it { is_expected.to validate_presence_of :email }

  context :create do
    it 'creates a valid media' do
      expect(User.new(
               email:                 'john@example.org',
               password:              'password',
               password_confirmation: 'password'
             )
            ).to be_valid
    end
  end

  context :format do
    it 'validates the email format' do
      expect(FactoryBot.build(:user, email: 'fail')).to be_invalid
      expect(FactoryBot.build(:user, email: 'fail@')).to be_invalid
      expect(FactoryBot.build(:user, email: 'fail@fail')).to be_invalid
      expect(FactoryBot.build(:user, email: 'fail@fail.')).to be_invalid

      expect(FactoryBot.build(:user, email: 'ok@ok.ok')).to be_valid
    end
  end

  context :uniqueness do
    let(:user) { FactoryBot.create :user }

    it 'does not allow the same email' do
      expect(FactoryBot.build(:user, email: user.email)).to be_invalid
    end
  end

  context :confirmation do
    it 'has a invalid one' do
      expect(User.new(
               email:                 'john@example.org',
               password:              'password',
               password_confirmation: 'password_wrong'
             )
            ).not_to be_valid
    end
  end
end
