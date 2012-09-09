# coding: utf-8

class Article < ActiveRecord::Base
  attr_readonly :user_id
  attr_accessible :title, :slug, :body, :category_ids, :published_at

  belongs_to :user, :counter_cache => true
  has_many :comments, :dependent => :destroy
  has_and_belongs_to_many :categories

  default_scope order("published_at desc")

  scope :recents, limit(10)
  scope :published, where('published_at is not null and published_at <= ?', Time.now)
  scope :drafts, where('published_at is null or published_at > ?', Time.now)

  validates :title, :slug, :user, :categories, :presence => true

  def text
    self.body.gsub(/\s{1}<!--more-->/, "")
  end

  def resume
    if self.body.nil? or self.body.index("<!--more-->").nil?
      self.body
    else
      "#{self.body.split("<!--more-->")[0]}..."
    end
  end

  def unique_comments
    self.comments.all(:group => "email")
  end

  def slug_it(text)
    text = text.downcase
    text = text.gsub(/\s-\s/, '-')
    text = text.gsub(/\s/, '-')

    from  = "áàãâäèéêëìíîïõòóôöùúûüç"
    to    = "aaaaaeeeeiiiiooooouuuuc"

    text = text.tr(from, to)
    text = text.gsub(/[^\w-]/, '')

    text
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

  def status
    if created_at.nil?
      I18n.t("article.status.new")
    elsif published_at.nil?
      I18n.t("article.status.draft")
    else
      I18n.t("article.status.published")
    end
  end

end
