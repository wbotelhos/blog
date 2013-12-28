# By Washington Botelho (http://wbotelhos.com)

require File.expand_path('../boot', __FILE__)
require File.expand_path('../../lib/custom_logger.rb', __FILE__)
require File.expand_path('../../lib/param_constraints.rb', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'active_resource/railtie'

Bundler.require(*Rails.groups(assets: %w[development test])) if defined?(Bundler)

module Blog
  class Application < Rails::Application
    config.action_view.field_error_proc       = -> tag, _ { tag }
    config.active_record.whitelist_attributes = true
    config.assets.enabled                     = false
    config.assets.enabled                     = true
    config.assets.initialize_on_precompile    = false
    config.assets.precompile                  += %w[labs.css labs.js]
    config.assets.version                     = '1.0'
    config.encoding                           = 'utf-8'
    config.filter_parameters                  += [:password]
    config.i18n.default_locale                = :'pt-BR'
    config.i18n.load_path                     += Dir[Rails.root.join('config/locales/**/*.yml').to_s]
    config.time_zone                          = 'Brasilia'

    config.middleware.swap Rails::Rack::Logger, CustomLogger
  end
end
