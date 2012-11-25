ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'capybara/rails'
require 'database_cleaner'
require 'rspec/autorun'
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

DatabaseCleaner.strategy = :truncation, { pre_count: true }

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false

  config.before do
    DatabaseCleaner.clean
  end
end
