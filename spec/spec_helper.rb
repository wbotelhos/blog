require 'rubygems'
require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'

  require File.expand_path('../../config/environment', __FILE__)
  require 'capybara/rails'
  require 'database_cleaner'
  require 'rspec/rails'

  Rails.logger.level = :error unless ENV['LOG']

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  RSpec.configure do |config|
    config.filter_run focus: true
    config.infer_base_class_for_anonymous_controllers      = false
    config.run_all_when_everything_filtered                = true
    config.treat_symbols_as_metadata_keys_with_true_values = true

    config.before :suite do
      DatabaseCleaner.clean_with :truncation, { pre_count: true }
    end

    config.before { DatabaseCleaner.strategy = :transaction }

    config.before js: true do
      DatabaseCleaner.strategy = :truncation, { pre_count: true }
    end

    config.before { DatabaseCleaner.start }
    config.after  { DatabaseCleaner.clean }
  end
end

Spork.each_run do
end
