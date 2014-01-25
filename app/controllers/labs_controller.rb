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

  def export
    url      = "#{CONFIG['url_http']}/#{@media.slug}?offline"
    response = Aitch.get url

    return unless response.success?

    AssetExtractor.new(@media, response).process
  end

  def gridy
    filter = get_filter
    model  = []

    begin
      if filter[:search].present?
        model = Lab.where filter[:find] => Regexp.new(".*#{filter[:search]}.*", "i")
      else
        model = Lab
      end

      model = model.order("#{filter[:sort_name]} #{filter[:sort_order]}").offset(MAX_ROWS).skip(filter[:skip])

      render json: { list: model, total: model.count }
    # rescue
      # render json: { list: [], total: 0, error: I18n.t('mongoid.errors.messages.document_not_found') }
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
