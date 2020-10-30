# frozen_string_literal: true

RSpec.describe PasswordEncryptor do
  describe '#encrypt' do
    it 'returns password hash' do
      expect(described_class.encrypt(:password)).to have_key :hash
    end

    it 'returns password salt' do
      expect(described_class.encrypt(:password)).to have_key :salt
    end

    it 'encrypts password' do
      encryption  = described_class.encrypt :password
      actual_hash = described_class.hasher :password, encryption[:salt]

      expect(actual_hash).to eq encryption[:hash]
    end
  end

  describe '#encryptor' do
    it 'delegates to Digest::SHA1' do
      expect(described_class.encryptor).to be Digest::SHA1
    end
  end
end
