Rails.application.configure do
  config.action_controller.perform_caching         = false
  config.action_mailer.asset_host                  = 'localhost:3000'
  config.action_mailer.default_url_options         = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method             = :smtp
  config.action_mailer.raise_delivery_errors       = true
  config.action_mailer.smtp_settings               = { address: 'localhost', port: 1025 }
  config.action_view.raise_on_missing_translations = true
  config.active_record.migration_error             = :page_load
  config.active_support.deprecation                = :log
  config.assets.debug                              = true
  config.assets.raise_runtime_errors               = true
  config.cache_classes                             = false
  config.consider_all_requests_local               = true
  config.eager_load                                = false
end
