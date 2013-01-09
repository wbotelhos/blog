class LinksController < ApplicationController
  before_filter :require_login, except: :index

  def create
    @link = Link.new params[:link]

    if @link.save
      redirect_to root_path, notice: t('flash.links.create.notice')
    else
      render :new, layout: 'admin'
    end
  end

  def edit
    @link = Link.find params[:id]
    render layout: 'admin'
  end

  def new
    @link = Link.new
    render layout: 'admin'
  end

  def update
    @link = Link.find params[:id]

    if @link.update_attributes params[:link]
      redirect_to root_path, notice: t('flash.links.update.notice')
    else
      render :edit, layout: 'admin'
    end
  end
end
