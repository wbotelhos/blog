class LabsController < ApplicationController
  before_filter :require_login, only: [:drafts, :edit, :create, :new, :update]

  def create
    @lab = Lab.new params[:lab]

    if @lab.save
      redirect_to labs_drafts_path, notice: t('flash.labs.draft.notice')
    else
      flash[:alert] = get_errors
      render :new, layout: 'admin'
    end
  end

  def drafts
    @labs = Lab.drafts
    render :index, layout: 'admin'
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

  def update
    lab = Lab.find params[:id]
    lab.update_attributes params[:lab]
    redirect_to labs_edit_path(lab), notice: t('flash.labs.update.notice')
  end

  private

  def get_errors
    error = ''

    @lab.errors.messages.each do |message|
      error += message[1][0] + "<br />"
    end

    error.html_safe
  end
end
