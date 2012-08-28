class LabsController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :edit, :update]

  def create
    @lab = Lab.new(params[:lab])

    if @lab.save
      flash[:notice] = t("flash.labs.create.notice")
      redirect_to labs_path
    else
      render :new, :layout => "admin"
    end
  end

  def edit
    @lab = Lab.find(params[:id])
    render :layout => "admin"
  end

  def index
    @labs = Lab.all
    render :layout => "admin"
  end

  def new
    @lab = Lab.new
    render :layout => "admin"
  end

  def update
    lab = Lab.find(params[:id])

    lab.update_attributes(params[:lab])

    redirect_to edit_lab_path(lab), :notice => t("flash.labs.update.notice")
  end
end
