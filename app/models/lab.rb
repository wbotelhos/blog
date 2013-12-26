class Lab < ActiveRecord::Base
  attr_accessible :body, :description, :published_at, :slug, :title, :version

  scope :by_created    , -> { order 'created_at desc' }
  scope :by_published  , -> { order 'published_at desc' }
  scope :drafts        , -> { where 'published_at is null or published_at > ?', Time.now }
  scope :home_selected , -> { select 'published_at, slug, title' }
  scope :published     , -> { where 'published_at is not null and published_at <= ?', Time.now }

  validates :slug    , presence: true , if: -> e { e.title.present?}
  validates :title   , presence: true , uniqueness: true
  validates :version , presence: true

  def download
    "#{CONFIG['github']}/#{slug}/archive/#{version}.zip"
  end

  def github
    "#{CONFIG['github']}/#{slug}"
  end

  def url
    "#{CONFIG['url_http']}/#{slug}"
  end
end
