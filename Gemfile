source 'https://rubygems.org'

gem 'action_args'
gem 'acts_as_tree'
gem 'aitch'
gem 'compass-rails'
gem 'mysql2'
gem 'nokogiri'
gem 'non-stupid-digest-assets'
gem 'pygments.rb'
gem 'rails', '~> 4.1.6'
gem 'rake'
gem 'redcarpet'
gem 'sass-rails', '4.0.3'
gem 'turbolinks'
gem 'uglifier'

# avoids: ActionView::Template::Error (wrong number of arguments (2 for 1)
# sass-rails (~> 4.0.3) ruby depends on sprockets (<= 2.11.0, ~> 2.8) ruby
gem 'sprockets', '2.11.0'

group :development do
  gem 'capistrano-bundler' , require: false
  gem 'capistrano-rails'   , require: false
end

group :development, :test do
  gem 'guard-rspec'
  gem 'pry-meta'
  gem 'spring-commands-rspec'
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
