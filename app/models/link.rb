class Link < ActiveRecord::Base
  attr_accessible :name, :url

  default_scope -> { order 'name asc' }

  validates :name, :url, presence: true, uniqueness: true
end
