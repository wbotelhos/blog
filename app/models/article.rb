# coding: utf-8

class Article < ActiveRecord::Base
  MORE_TAG = '<!--more-->'

  attr_readonly :user_id
  attr_accessible :title, :slug, :body, :category_ids, :published_at

  belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :categories

  default_scope order 'published_at desc'

  scope :recents, limit(10)
  scope :published, where('published_at is not null and published_at <= ?', Time.now)
  scope :drafts, where('published_at is null or published_at > ?', Time.now)

  before_validation :slug_it, if: -> e { e.title }

  validates :title, :slug, :user, :categories, presence: true

  def text
    body.gsub(/\s{1}#{MORE_TAG}/, '')
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

  def slug_it
    from  = 'áàãâäèéêëìíîïõòóôöùúûüç'
    to    = 'aaaaaeeeeiiiiooooouuuuc'

    slug = title.downcase

    slug.gsub!(/\s-\s/, '-')
    slug.gsub!(/\s/, '-')
    slug.tr!(from, to)
    slug.gsub!(/[^\w-]/, '')

    write_attribute(:slug, slug)
  end

  def with_zero
    return '00' if published_at.nil?
    value = yield
    (value < 10) ? "0#{value}" : value
  end
end
