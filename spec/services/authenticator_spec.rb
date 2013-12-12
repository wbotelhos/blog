require 'spec_helper'

describe Authenticator do
  let(:user) { FactoryGirl.create :user }

  context 'with valid credentials' do
    it 'returns user' do
      expect(Authenticator.authenticate user.email, :password).to eq user
    end
  end

  context 'with invalid credentials' do
    it 'returns nothing' do
      expect(Authenticator.authenticate user.email, :invalid).to be_nil
    end
  end
end
