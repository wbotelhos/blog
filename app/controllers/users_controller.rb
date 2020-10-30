# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_login
  before_action :find, only: %i[edit update]

  def edit; end

  def update
    user = parameters

    user.delete(:password) if user[:password].blank?

    if @user.update(user)
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def find
    @user = User.find session[:user_id]
  end

  def parameters
    params.require(:user).permit :email, :password, :password_confirmation
  end
end
