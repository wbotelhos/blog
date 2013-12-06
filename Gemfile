source 'https://rubygems.org'

gem 'acts_as_tree'
gem 'asset_sync'
gem 'cancan'
gem 'devise'
gem 'html_compress'
gem 'mysql2'
gem 'pygments.rb'
gem 'rails'         , '~> 3.2.15'
gem 'redcarpet'
gem 'sass-rails'
gem 'thin'

group :assets do
  gem 'compass-rails'
  gem 'turbo-sprockets-rails3'
  gem 'uglifier'
end

group :development do
  gem 'capistrano', '~> 2.15.5'
end

group :development, :test do
  gem 'debugger'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'pry-meta'     , require: false
  gem 'quiet_assets'
  gem 'rb-fsevent'   , require: false
  gem 'ruby_gntp'    # require: http://growl.info/downloads
end

group :production do
  gem 'unicorn'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'mongoid-rspec'
  gem 'rack_session_access'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda'
end
