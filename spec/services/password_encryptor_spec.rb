require 'rails_helper'

describe PasswordEncryptor do
  describe '#encrypt' do
    it 'returns password hash' do
      expect(PasswordEncryptor.encrypt :password).to have_key :hash
    end

    it 'returns password salt' do
      expect(PasswordEncryptor.encrypt :password).to have_key :salt
    end

    it 'encrypts password' do
      encryption  = PasswordEncryptor.encrypt :password
      actual_hash = PasswordEncryptor.hasher :password, encryption[:salt]

      expect(actual_hash).to eq encryption[:hash]
    end
  end

   describe '#encryptor' do
    it 'delegates to Digest::SHA1' do
      expect(PasswordEncryptor.encryptor).to be Digest::SHA1
    end
  end
end
