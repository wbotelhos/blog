class Article < ActiveRecord::Base
  attr_readonly :user_id
  attr_accessible :title, :body, :category_ids, :published_at

  belongs_to :user, :counter_cache => true
  has_many :comments, :dependent => :destroy
  has_and_belongs_to_many :categories

  scope :recents, limit(10).order("published_at desc")

  validates :title, :body, :user, :categories, :presence => true

  def formatted
    self.body.gsub(/\s{1}<!--more-->/, "")
  end

  def resume
    "#{self.body.split("<!--more-->")[0]}..." unless self.body.nil?
  end

  def unique_comments
    self.comments.all(:group => "email")
  end  

  def unique_comments
    self.comments.all(:group => "email")
  end  

  define_index do
    set_property :delta => true

    indexes title
    indexes body
  end

end
