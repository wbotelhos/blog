module Blogy
  class Application < Rails::Application
    config.assets.initialize_on_precompile = true
    config.assets.version                  = '1.0'

    # https://github.com/sstephenson/sprockets/issues/347#issuecomment-25543201
    # Removing the default: precompile * != [js, css]. Too much things.
    config.assets.precompile.shift

    # What we want precompile.
    config.assets.precompile.push -> path {
      File.extname(path).in? [
        '.html' , '.erb'  ,                     # Templates
        '.jpg'  ,  '.png' , '.gif'  , '.svg'  , # Images
        '.eot'  ,  '.svg' , '.ttf'  , '.woff' , # Fonts
      ]
    }
  end
end
