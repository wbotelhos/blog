# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Article do
  it 'has a valid factory' do
    expect(FactoryBot.build(:article)).to be_valid
  end

  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :title }

  it { expect(FactoryBot.build(:article)).to validate_uniqueness_of(:title).case_insensitive }
end
