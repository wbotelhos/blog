class UsersController < ApplicationController
  before_filter :require_login, except: [:about]

  def about
    @author = User.first
  end

  def create
    @user = User.new params[:user]

    if @user.save
      redirect_to users_url, notice: t('flash.users.create.notice')
    else
      render :new, layout: 'admin'
    end
  end

  def edit
    @user = User.find params[:id]
    render layout: 'admin'
  end

  def index
    @users = User.all
    render layout: 'admin'
  end

  def new
    @user = User.new
    render layout: 'admin'
  end
end
