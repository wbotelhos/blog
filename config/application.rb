require File.expand_path '../boot', __FILE__
require File.expand_path('../../lib/param_constraints.rb', __FILE__)
require 'rails/all'

Bundler.require *Rails.groups

module Blogy
  class Application < Rails::Application
    config.action_view.field_error_proc = -> tag, _ { tag }
    config.assets.precompile            += %w[labs.css labs.js session.css session.js]
    config.autoload_paths               << Rails.root.join('app/services')
    config.i18n.default_locale          = :pt
    config.i18n.load_path               += Dir[Rails.root.join('config/locales/**/*.yml').to_s]
    config.time_zone                    = 'Brasilia'
  end
end
