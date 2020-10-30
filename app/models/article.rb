# frozen_string_literal: true

class Article < ApplicationRecord
  attr_readonly :user_id

  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy

  scope :by_created,    -> { order 'created_at desc' }
  scope :by_published,  -> { order 'published_at desc' }
  scope :drafts,        -> { where 'published_at is null or published_at > ?', Time.current }
  scope :home_selected, -> { select 'id, published_at, slug, title' }
  scope :published,     -> { where 'published_at is not null and published_at <= ?', Time.current }
  scope :recents,       -> { limit 10 }

  before_validation :generate_slug, if: -> { title.present? }

  validates :slug,  presence: true, if: -> { title.present? }
  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }
  validates :user,  presence: true

  def published?
    published_at.present?
  end

  def publish!
    self[:published_at] = Time.current

    save
  end

  private

  def generate_slug
    self[:slug] = title.parameterize
  end
end
