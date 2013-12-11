class UsersController < ApplicationController
  before_filter :require_login, except: :donate

  layout 'admin'

  def donate
    render layout: 'application'
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]

    if @user.update_attributes params[:user]
      redirect_to admin_url
    else
      render :edit
    end
  end
end
