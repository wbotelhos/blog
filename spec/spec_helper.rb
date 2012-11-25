ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'capybara/rails'
require 'database_cleaner'
require 'rspec/autorun'
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false

  config.before :suite do
    DatabaseCleaner.strategy = :truncation
  end
end
