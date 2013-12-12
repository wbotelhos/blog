class LabsController < ApplicationController
  before_filter :require_login, except: :index

  def create
    @lab = Lab.new params[:lab]

    if @lab.save
      redirect_to labs_drafts_url, notice: t('flash.labs.draft.notice')
    else
      render :new, layout: 'admin'
    end
  end

  def edit
    @lab = Lab.find params[:id]
    render layout: 'admin'
  end

  def index
    @labs = Lab.published
  end

  def new
    @lab = Lab.new
    render layout: 'admin'
  end

  def show
  end

  def update
    @lab = Lab.find params[:id]

    if @lab.update_attributes params[:lab]
      redirect_to labs_url, notice: t('flash.labs.update.notice')
    else
      render :edit, layout: 'admin'
    end
  end
end
