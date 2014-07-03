class LabsController < ApplicationController
  before_filter :require_login, except: [:index, :show]
  before_filter :find, only: [:edit, :export, :update]

  layout 'application'

  MAX_ROWS = 100

  def create
    @media = Lab.new params[:lab]

    if @media.save
      redirect_to edit_lab_url @media
    else
      render :new
    end
  end

  def edit
  end

  def export_
    url      = "#{CONFIG['url_http']}/#{@media.slug}?offline"
    response = Aitch.get url

    return unless response.success?

    AssetExtractor.new(@media, response).process

    render nothing: true
  end

  def gridy
    filter   = get_filter
    criteria = Lab.select('title, description, version')

    begin
      if filter[:search].present?
        criteria = criteria.where filter[:find] => Regexp.new(".*#{filter[:search]}.*", "i")
      end

      sql = criteria
            .order("#{filter[:sort_name]} #{filter[:sort_order]}")
            .offset(MAX_ROWS)
            .skip(filter[:skip])
            .to_sql

      result = Lab.find_by_sql sql

      render json: { list: result, total: result.count }
    rescue ActiveRecord::RecordNotFound
      render json: { list: [], total: 0, error: I18n.t('lab.errors.not_found') }
    end
  end

  def index
    @year_month_medias = Lab.home_selected.published.by_published.group_by { |criteria| criteria.published_at.strftime('%m/%Y') }
  end

  def new
    @media = Lab.new
  end

  def show
    @media = Lab.where('slug = ?', params[:slug]).first

    if @media.present?
      @comment       = @media.comments.new
      @root_comments = @media.comments.roots
      @title         = "#{@media.title} | #{@media.description}"

      render layout: 'labs'
    else
      redirect_to root_url, alert: t('article.flash.not_found', uri: params[:slug])
    end
  end

  def update
    if @media.update_attributes params[:lab]
      redirect_to edit_lab_url @media
    else
      render :edit
    end
  end

  private

  def find
    @media = Lab.find params[:id]
  end

  def get_filter
    hash = {
      address:    params[:address],
      find:       params[:find],
      page:       params[:page].to_i,
      search:     params[:search],
      sort_name:  params[:sortName],
      sort_order: params[:sortOrder],
      rows:       params[:rows].to_i
    }

    page = hash[:page] - 1
    page = 0 if page < 0

    hash[:skip] = page * hash[:rows]

    hash
  end

  def rows_for(filter)
    filter[:rows] > MAX_ROWS ? MAX_ROWS : filter[:rows]
  end
end
