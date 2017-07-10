class Lab < ActiveRecord::Base
  has_many :comments, as: :commentable, dependent: :destroy

  scope :by_created,    -> { order 'created_at desc' }
  scope :by_published,  -> { order 'published_at desc' }
  scope :drafts,        -> { where 'published_at is null or published_at > ?', Time.current }
  scope :home_selected, -> { select 'published_at, slug, title' }
  scope :published,     -> { where 'published_at is not null and published_at <= ?', Time.current }

  validates :analytics,   presence: true
  validates :description, presence: true
  validates :keywords,    presence: true
  validates :slug,        presence: true, if: ->(e) { e.title.present? }
  validates :title,       presence: true, uniqueness: true
  validates :version,     presence: true

  def download
    "#{github}/archive/#{version}.zip"
  end

  def github
    "http://github.com/#{CONFIG['github']}/#{slug}"
  end

  def javascripts
    build_tag js_import, %(<script src="{{url}}"></script>)
  end

  def javascripts_inline # TODO: avoid the max character here.
    js.html_safe if js.present?
  end

  def javascripts_ready
    js_ready.html_safe if js_ready.present?
  end

  def stylesheets
    build_tag css_import, %(<link rel="stylesheet" href="{{url}}">)
  end

  def stylesheets_inline
    "<style>#{css}</style>".html_safe if css.present?
  end

  def url
    "#{CONFIG['url_http']}/#{slug}"
  end

  private

  def build_tag(attribute, template)
    if attribute.present?
      attribute.delete(' ').split(',').map do |url|
        template.sub '{{url}}', url
      end.join('').html_safe
    end
  end
end
