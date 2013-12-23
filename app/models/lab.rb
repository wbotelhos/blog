class Lab < ActiveRecord::Base
  attr_accessible :description, :image, :name, :slug

  scope :by_id     , -> { order 'id desc' }
  scope :drafts    , -> { where 'published_at is null or published_at > ?', Time.now }
  scope :published , -> { where 'published_at is not null and published_at <= ?', Time.now }

  validates :name, :slug, presence: true, uniqueness: true

  def github
    "#{CONFIG['github']}/#{slug}"
  end

  def url
    "#{CONFIG['url_http']}/#{slug}"
  end
end
