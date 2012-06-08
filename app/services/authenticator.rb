class Authenticator

  def self.authenticate(email, password)
    user = User.find_by_email(email)

    return unless user

    actual_hash = PasswordEncryptor.hasher(password, user.password_salt)

    return user if user.password_hash == actual_hash
  end

end
