class Lab < ActiveRecord::Base
  attr_accessible :body, :css_import, :description, :js, :js_import, :js_ready, :keywords, :published_at, :slug, :title, :version

  scope :by_created    , -> { order 'created_at desc' }
  scope :by_published  , -> { order 'published_at desc' }
  scope :drafts        , -> { where 'published_at is null or published_at > ?', Time.now }
  scope :home_selected , -> { select 'published_at, slug, title' }
  scope :published     , -> { where 'published_at is not null and published_at <= ?', Time.now }

  validates :description , :keywords , :version , presence: true
  validates :slug                               , presence: true , if: -> e { e.title.present?}
  validates :title                              , presence: true , uniqueness: true

  def download
    "#{CONFIG['github']}/#{slug}/archive/#{version}.zip"
  end

  def github
    "#{CONFIG['github']}/#{slug}"
  end

  def javascripts
    js_import.delete(' ').split(',').map do |url|
      %(<script src="#{url}"></script>)
    end.join('').html_safe if js_import.present?
  end

  def stylesheets
    css_import.delete(' ').split(',').map do |url|
      %(<link rel="stylesheet" href="#{url}">)
    end.join('').html_safe if css_import.present?
  end

  def url
    "#{CONFIG['url_http']}/#{slug}"
  end
end
