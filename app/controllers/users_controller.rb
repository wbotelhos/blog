class UsersController < ApplicationController
  before_filter :require_login

  def edit
    @user = User.find session[:user_id]
  end

  def update
    @user = User.find session[:user_id]

    if @user.update_attributes params[:user]
      redirect_to profile_path
    else
      render :edit
    end
  end
end
