class SessionsController < ApplicationController
  layout 'login'

  def new
    redirect_to root_url if session[:user_id]
  end

  def create
    reset_session

    user = Authenticator.authenticate params[:email], params[:password]

    if user
      session[:user_id] = user.id
      redirect_to admin_url
    else
      flash.now[:alert] = t('flash.sessions.create.alert')
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
