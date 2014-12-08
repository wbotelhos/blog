#ruby=ruby-2.1.3
#ruby-gemset=blogy

source 'https://rubygems.org'

gem 'action_args'
gem 'acts_as_tree'
gem 'aitch'
gem 'compass-rails'
gem 'mysql2'
gem 'nokogiri'
gem 'pygments.rb'
gem 'rails'
gem 'rake'
gem 'redcarpet'
gem 'sass-rails'
gem 'sprockets', '2.11.0' # avoids: ActionView::Template::Error (wrong number of arguments (2 for 1)
gem 'uglifier'
gem 'sprockets_better_errors'
gem 'non-stupid-digest-assets'

# loading just fog storage for otimization.
gem 'fog', require: 'fog/aws/storage'
gem 'asset_sync'

group :development do
  gem 'capistrano' , '~> 2.15.0'
end

group :development, :test do
  gem 'guard-rspec'
  gem 'pry-meta'
  gem 'quiet_assets'
  gem 'rb-fsevent'
  gem 'spring-commands-rspec'
  gem 'thin'
end

group :production do
  gem 'unicorn'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'rack_session_access'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
end
