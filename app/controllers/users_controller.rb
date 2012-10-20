class UsersController < ApplicationController
  before_filter :require_login, except: [:about]

  def about
    @author = User.first
  end

  def create
    @user = User.new params[:user]

    if @user.save
      flash[:notice] = t('flash.users.create.notice')
      redirect_to login_path
    else
      render :new, layout: 'admin'
    end
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
