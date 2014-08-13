class UsersController < ApplicationController
  permits :email, :password, :password_confirmation

  before_filter :require_login
  before_filter :find, only: [:edit, :update]

  def edit
  end

  def update(user)
    user.delete(:password) if user[:password].blank?

    if @user.update_attributes user
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def find
    @user = User.find session[:user_id]
  end
end
