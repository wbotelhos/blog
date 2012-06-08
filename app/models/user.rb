class User < ActiveRecord::Base
  attr_accessible :name, :email, :bio, :url, :github, :linkedin, :twitter, :facebook, :password, :password_confirmation
  attr_reader :password

  validates :name, :email, :password, :presence => true
  validates :email,                   :uniqueness => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :password,                :confirmation => true

  has_many :articles, :dependent => :nullify

  def password=(password)
    encryption = PasswordEncryptor.encrypt(password)

    self.password_salt = encryption[:salt]
    self.password_hash = encryption[:hash]

    @password = password
  end
end
