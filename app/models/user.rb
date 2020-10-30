# frozen_string_literal: true

class User < ApplicationRecord
  attr_reader :password

  has_many :articles, dependent: :nullify

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, confirmation: true, if: -> { password.present? }

  def password=(password)
    encryption = PasswordEncryptor.encrypt password

    self.password_salt = encryption[:salt]
    self.password_hash = encryption[:hash]

    @password = password
  end
end
