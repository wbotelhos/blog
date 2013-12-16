class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :filter_bot

  helper_method :current_user, :is_logged?, :sidebar

  rescue_from ActiveRecord::RecordNotFound do
    case request.format.symbol
    when :html
      render file: Rails.root.join('public/404.html'), layout: false, status: 404
    when :json
      render json: { error: t('article.no_result') }, status: 404
    end
  end

  private

  def current_user#
    @current_user ||= session[:user_id] && User.find_by_id(session[:user_id])
  end

  def is_logged?#
    current_user.present?
  end

  def require_login
    redirect_to login_url, alert: t('session.required') unless is_logged?
  end

  def sidebar
    @sidebar ||= SidebarPresenter.new
  end

  def filter_bot
    if !is_logged? && params[:bot].present?
      logger.warn 'B0T on request!'
      render nothing: true, status: 404
    end
  end

  protected

  def handle_unverified_request
    reset_session
    logger.warn 'B0T with no csrf!'
    render nothing: true, status: 404
  end
end
