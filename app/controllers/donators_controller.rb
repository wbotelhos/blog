class DonatorsController < ApplicationController
  before_filter :require_login, only: [:edit, :create, :new, :update]

  def create
    @donator = Donator.new params[:donator]

    if @donator.save
      redirect_to donators_path, notice: t('flash.donators.create.notice')
    else
      render :new, layout: 'admin'
    end
  end

  def edit
    @donator = Donator.find params[:id]
    render layout: 'admin'
  end

  def index
    @donators = Donator.all
  end

  def new
    @donator = Donator.new
    render layout: 'admin'
  end

  def update
    donator = Donator.find params[:id]
    donator.update_attributes params[:donator]
    redirect_to donators_path(donator), notice: t('flash.donators.update.notice')
  end
end
