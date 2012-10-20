class Lab < ActiveRecord::Base
  attr_accessible :name, :slug, :description, :image

  scope :published, where('published_at is not null and published_at <= ?', Time.zone.now)
  scope :drafts, where('published_at is null or published_at > ?', Time.zone.now)

  validates :name, :slug, presence: true
  validates :name, :slug, uniqueness: true
end
