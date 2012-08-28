class Lab < ActiveRecord::Base
  attr_accessible :name, :slug, :description

  validates :name, :slug, :presence => true
  validates :name, :slug, :uniqueness => true
end
