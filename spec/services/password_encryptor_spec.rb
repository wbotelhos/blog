require 'spec_helper'

describe PasswordEncryptor do
  describe "#encrypt" do
    it "returns password hash" do
      PasswordEncryptor.encrypt('password').should have_key :hash
    end

    it "returns password salt" do
      PasswordEncryptor.encrypt('password').should have_key :salt
    end

    it "encrypts password" do
      encryption = PasswordEncryptor.encrypt 'password'
      actual_hash = PasswordEncryptor.hasher('password', encryption[:salt])

      actual_hash.should == encryption[:hash]
    end
  end

   describe "#encryptor" do
    it "delegates to Digest::SHA1" do
      PasswordEncryptor.encryptor.should be Digest::SHA1
    end
  end
end
