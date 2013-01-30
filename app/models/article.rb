# coding: utf-8

class Article < ActiveRecord::Base
  MORE_TAG = '<!--more-->'

  attr_readonly :user_id
  attr_accessible :title, :slug, :body, :category_ids, :published_at

  belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :categories

  default_scope order 'published_at desc'

  scope :recents,   limit(10)
  scope :published, where('published_at is not null and published_at <= ?', Time.zone.now)
  scope :drafts,    where('published_at is null or published_at > ?', Time.zone.now)

  scope :by_category, -> category do
    self.all(joins: :categories, conditions: { 'categories.slug' => category }) & self.published
  end

  before_validation :generate_slug, if: -> e { e.title.present?}

  validates :title, presence: true, uniqueness: true
  validates :user, :categories, presence: true
  validates :slug, presence: true, if: -> e { e.title.present?}

  def text
    body.gsub /\s{1}#{MORE_TAG}/, ''
  end

  def resume
    (body && body.index(MORE_TAG)) ? "#{body.split(MORE_TAG)[0]}..." : body
  end

  def comments_to_mail
    comments.where('author = false').all(group: 'email')
  end

  def day
    with_zero { published_at.day }
  end

  def month
    with_zero { published_at.month }
  end

  def year
    return '0000' if published_at.nil?
    year = published_at.year
    (year < 10) ? "000#{year}" : year
  end

  define_index do
    set_property delta: true

    indexes title
    indexes body
  end

  def status
    if created_at.nil?
      I18n.t('article.status.new')
    elsif published_at.nil?
      I18n.t('article.status.draft')
    else
      I18n.t('article.status.published')
    end
  end

  private

  def generate_slug
    write_attribute :slug, title.slug
  end

  def with_zero
    return '00' if published_at.nil?
    value = yield
    (value < 10) ? "0#{value}" : value
  end
end
