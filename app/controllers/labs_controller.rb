class LabsController < ApplicationController
  before_filter :require_login, except: [:index, :show]

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
    @media = Lab.find params[:id]
  end

  def index
    @year_month_medias = Lab.home_selected.published.by_published.group_by { |criteria| criteria.published_at.strftime('%m/%Y') }
  end

  def new
    @media = Lab.new
  end

  def show
    @media = Lab.where('slug = ?', params[:slug]).first

    unless @media.present?
      redirect_to root_url, alert: t('lab.flash.not_found', uri: params[:slug])
    end

    render layout: 'labs'
  end

  def update
    @media = Lab.find params[:id]

    if @media.update_attributes params[:lab]
      redirect_to edit_lab_url @media
    else
      render :edit
    end
  end
end
