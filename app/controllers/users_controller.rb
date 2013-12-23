class UsersController < ApplicationController
  before_filter :require_login

  def edit
    @user = User.find session[:user_id]
  end

  def update
    @user = User.find session[:user_id]

    filter_unchanged_password

    if @user.update_attributes params[:user]
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def filter_unchanged_password
    params[:user].delete(:password) if params[:user][:password].blank?
  end
end
