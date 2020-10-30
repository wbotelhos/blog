# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe User do
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it { is_expected.to validate_presence_of :email }

  it { expect(FactoryBot.build(:user)).to validate_uniqueness_of(:email).case_insensitive }

  it 'creates a valid media' do
    expect(described_class.new(
             email:                 'john@example.org',
             password:              'password',
             password_confirmation: 'password'
           )
          ).to be_valid
  end

  it 'validates the email format' do
    expect(FactoryBot.build(:user, email: 'fail')).to be_invalid
    expect(FactoryBot.build(:user, email: 'fail@')).to be_invalid
    expect(FactoryBot.build(:user, email: 'fail@fail')).to be_invalid
    expect(FactoryBot.build(:user, email: 'fail@fail.')).to be_invalid

    expect(FactoryBot.build(:user, email: 'ok@ok.ok')).to be_valid
  end

  it 'has a invalid one' do
    expect(described_class.new(
             email:                 'john@example.org',
             password:              'password',
             password_confirmation: 'password_wrong'
           )
          ).not_to be_valid
  end
end
