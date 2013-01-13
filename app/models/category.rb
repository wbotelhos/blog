class Category < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :articles

  default_scope order 'name asc'

  before_validation :generate_slug, if: -> e { e.name.present?}

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, if: -> e { e.name.present?}

  private

  def generate_slug
    write_attribute :slug, name.slug
  end
end
