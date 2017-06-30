module Blogy
  class Application < Rails::Application
    config.assets.initialize_on_precompile = true
    config.assets.version                  = '1.0'
  end
end
