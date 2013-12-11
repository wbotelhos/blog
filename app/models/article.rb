class Article < ActiveRecord::Base
  attr_readonly :user_id

  attr_accessible :title, :slug, :body, :published_at

  belongs_to :user

  has_many :comments, dependent: :destroy

  scope :by_created   , -> { order 'created_at desc' }
  scope :by_published , -> { order 'published_at desc' }
  scope :drafts       , -> { where 'published_at is null or published_at > ?', Time.now }
  scope :published    , -> { where 'published_at is not null and published_at <= ?', Time.now }
  scope :recents      , -> { limit 10 }

  before_validation :generate_slug, if: -> e { e.title.present? }

  validates :slug  , presence: true , if: -> e { e.title.present?}
  validates :title , presence: true , uniqueness: true
  validates :user  , presence: true

  private

  def generate_slug
    write_attribute :slug, title.slug
  end
end
