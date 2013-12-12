class PasswordEncryptor
  def self.encrypt(password)
    salt = encryptor.hexdigest rand.to_s
    hash = hasher password, salt

    { hash: hash, salt: salt }
  end

  def self.hasher(password, salt)
    encryptor.hexdigest "--#{password}--#{salt}--"
  end

  def self.encryptor
    Digest::SHA1
  end
end
