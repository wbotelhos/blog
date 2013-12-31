require 'rails/all'

class CustomLogger < Rails::Rack::Logger
  def initialize(app)
    @app = app

    super
  end

  def call(env)
    level   = Rails.logger.level
    request = ActionDispatch::Request.new env
    params  = request.request_parameters

    if params[:bot].present?
      logger.warn %(B0T on "#{env['PATH_INFO']}"!)

      Rails.logger.level = Logger::ERROR

      @app.call env
    else
      super env
    end
  ensure
    Rails.logger.level = level
  end
end
