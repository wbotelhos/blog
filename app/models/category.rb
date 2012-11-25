class Category < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :articles

  default_scope order 'name asc'

  validates :name, presence: true
  validates :name, uniqueness: true
end
