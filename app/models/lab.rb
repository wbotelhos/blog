class Lab < ActiveRecord::Base
  attr_accessible :name, :slug, :description, :image

  default_scope order 'created_at desc'

  scope :published, where('published_at is not null and published_at <= ?', Time.zone.now)
  scope :drafts, where('published_at is null or published_at > ?', Time.zone.now)

  validates :name, :slug, presence: true
  validates :name, :slug, uniqueness: true

  def status
    if created_at.nil?
      I18n.t('lab.status.new')
    elsif published_at.nil?
      I18n.t('lab.status.draft')
    else
      I18n.t('lab.status.published')
    end
  end

  def github
    "http://github.com/wbotelhos/#{slug}"
  end

  def url
    "http://wbotelhos.com/#{slug}"
  end
end
