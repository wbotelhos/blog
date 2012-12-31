Blog::Application.configure do
  config.action_controller.perform_caching    = true
  config.action_mailer.asset_host             = 'http://wbotelhos.com.br'
  config.action_mailer.default_url_options    = { :host => 'wbotelhos.com.br' }
  config.action_mailer.delivery_method        = :smtp
  config.action_mailer.raise_delivery_errors  = false
  config.active_support.deprecation           = :notify
  config.cache_classes                        = true
  config.consider_all_requests_local          = false
  config.i18n.fallbacks                       = true
  config.serve_static_assets                  = false
  config.action_mailer.smtp_settings          = {
    address:                'email-smtp.us-east-1.amazonaws.com',
    user_name:              ENV['SES_USER'],
    password:               ENV['SES_PASSWORD'],
    authentication:         :login,
    enable_starttls_auto:   true,
    port:                   465
  }
end
