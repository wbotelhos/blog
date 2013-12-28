class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :filter_bot
  before_filter :set_locale

  helper_method :current_user, :is_logged?

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

  def set_locale
    I18n.locale = controller_name == 'labs' && action_name == 'show' ? :'en-US' : :'pt-BR'
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
