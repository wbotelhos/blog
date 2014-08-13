class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :filter_bot
  before_filter :set_locale

  helper_method :current_user, :is_logged?

  private

  def current_user
    @current_user ||= session[:user_id] && User.find_by_id(session[:user_id])
  end

  def filter_bot
    if params[:bot].present?
      logger.warn 'B0T on request!'
      render nothing: true, status: 404
    end
  end

  def is_logged?
    current_user.present?
  end

  def require_login
    redirect_to login_url, alert: t('session.required') unless is_logged?
  end

  def set_locale
    I18n.locale = controller_name == 'labs' && action_name == 'show' ? :en : :pt
  end

  protected

  def handle_unverified_request
    reset_session
    logger.warn 'B0T with no csrf!'
    render nothing: true, status: 404
  end
end
