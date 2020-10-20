ENV['RAILS_ENV'] ||= 'test'

require 'rails_helper'
require File.expand_path '../config/environment', __dir__
require 'rspec/rails'
require 'capybara/rails'
require 'database_cleaner'
require 'rack_session_access/capybara'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  Rails.logger.level = 4

  config.before :suite do
    DatabaseCleaner.clean_with :truncation, pre_count: true
  end

  config.before do |spec|
    if spec.metadata[:js]
      config.use_transactional_fixtures = false
      DatabaseCleaner.strategy          = :truncation

      page.driver.browser.manage.window.maximize
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  config.after do
    DatabaseCleaner.clean
  end
end
