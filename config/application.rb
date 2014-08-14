# By Washington Botelho (http://wbotelhos.com)

require File.expand_path('../boot', __FILE__)
require File.expand_path('../../lib/custom_logger.rb', __FILE__)
require File.expand_path('../../lib/param_constraints.rb', __FILE__)
require 'rails/all'

Bundler.require *Rails.groups

module Blogy
  class Application < Rails::Application
    config.action_view.field_error_proc = -> tag, _ { tag }
    config.assets.precompile            += %w[labs.css labs.js]
    config.i18n.default_locale          = :pt
    config.i18n.load_path               += Dir[Rails.root.join('config/locales/**/*.yml').to_s]
    config.time_zone                    = 'Brasilia'

    config.middleware.swap Rails::Rack::Logger, CustomLogger
  end
end
