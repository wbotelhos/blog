class LabsController < ApplicationController
  before_filter :require_login, except: [:index, :show]
  before_filter :find, only: [:edit, :export, :update]

  layout 'application'

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
    url      = "#{CONFIG['url_http']}/#{@media.slug}"
    response = Aitch.get url

    return unless response.success?

    AssetExtractor.new(@media, response).process
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
end
