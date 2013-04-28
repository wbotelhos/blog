class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :filter_bot

  helper_method :user_session, :is_logged?, :sidebar

  rescue_from ActiveRecord::RecordNotFound do
    case request.format.symbol
    when :html
      render file: Rails.root.join('public/404.html'), layout: false, status: 404
    when :json
      render json: { error: t('article.no_result') }, status: 404
    end
  end

  private

  def user_session
    @user_session ||= session[:user_id] && User.find_by_id(session[:user_id])
  end

  def is_logged?
    user_session.present?
  end

  def require_login
    redirect_to login_url, alert: t('flash.auth.alert') unless is_logged?
  end

  def sidebar
    @sidebar ||= SidebarPresenter.new
  end

  def filter_bot
    logger.warn 'B0T attacking, doing nothing...'
    render nothing: true, status: 404 if params[:bot].present?
  end

  protected

  def handle_unverified_request
    reset_session
    logger.warn 'B0T attacking "no csrf", doing nothing with 404!'
    render nothing: true, status: 404
  end
end
