# coding: utf-8

class Article < ActiveRecord::Base
  attr_readonly :user_id
  attr_accessible :title, :body, :category_ids, :published_at

  belongs_to :user, :counter_cache => true
  has_many :comments, :dependent => :destroy
  has_and_belongs_to_many :categories

  scope :recents, limit(10).order("published_at desc")
  scope :published, where('published_at is not null and published_at <= ?', Time.now)
  scope :unpublished, where('published_at is null or published_at > ?', Time.now)

  validates :title, :user, :categories, :presence => true

  def formatted
    self.body.gsub(/\s{1}<!--more-->/, "")
  end

  def resume
    "#{self.body.split("<!--more-->")[0]}..." unless self.body.nil?
  end

  def unique_comments
    self.comments.all(:group => "email")
  end

  # TODO: to use like slug.downcase! changes the title. Why?
  def slug_it
    slug = self.title

    slug = slug.downcase
    slug = slug.gsub(/\s-\s/, '-')
    slug = slug.gsub(/\s/, '-')

    from  = "áàãâäèéêëìíîïõòóôöùúûüç"
    to    = "aaaaaeeeeiiiiooooouuuuc"

    slug = slug.tr(from, to)
    
    slug = slug.gsub(/[^\w-]/, '')

    slug
  end

  def day
    return "00" if published_at.nil?

    day = self.published_at.day

    (day < 10) ? "0#{day}" : day
  end

  def month
    return "00" if published_at.nil?

    month = self.published_at.month

    (month < 10) ? "0#{month}" : month
  end

  def year
    return "0000" if published_at.nil?

    year = self.published_at.year

    (year < 10) ? "0#{year}" : year
  end

  define_index do
    set_property :delta => true

    indexes title
    indexes body
  end

end
