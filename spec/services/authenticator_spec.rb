# frozen_string_literal: true

RSpec.describe Authenticator do
  let(:user) { FactoryBot.create :user }

  context 'with valid credentials' do
    it 'returns user' do
      expect(described_class.authenticate(user.email, :password)).to eq user
    end
  end

  context 'with invalid credentials' do
    it 'returns nothing' do
      expect(described_class.authenticate(user.email, :invalid)).to be_nil
    end
  end
end
