# frozen_string_literal: true

I18n.load_path     += Dir[Rails.root.join('config', 'locales', '**/*.yml')] # should come first
I18n.default_locale = :'pt-BR'
I18n.locale         = :'pt-BR'
