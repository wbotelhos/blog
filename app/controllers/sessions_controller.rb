class SessionsController < ApplicationController
  layout 'session'

  def new
    redirect_to root_url if session[:user_id]

    @user = User.new
  end

  def create
    reset_session

    user = Authenticator.authenticate(params[:email], params[:password]) if params[:bot].blank?

    if user
      session[:user_id] = user.id

      redirect_to admin_url
    else
      flash.now[:alert] = t('sessions.flash.create.alert')
      @email            = params[:email]

      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
