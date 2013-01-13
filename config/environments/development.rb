Blog::Application.configure do
  config.action_controller.perform_caching               = false
  config.action_dispatch.best_standards_support          = :builtin
  config.action_mailer.asset_host                        = 'http://wbotelhos.com.br'
  config.action_mailer.default_url_options               = { host: 'wbotelhos.com.br' }
  config.action_mailer.delivery_method                   = :smtp
  config.action_mailer.raise_delivery_errors             = true
  config.action_mailer.smtp_settings                     = { address: 'localhost', port: 1025 }
  config.active_record.auto_explain_threshold_in_seconds = 0.5
  config.active_record.mass_assignment_sanitizer         = :strict
  config.active_support.deprecation                      = :log
  config.cache_classes                                   = false
  config.consider_all_requests_local                     = true
  config.whiny_nils                                      = true
end
