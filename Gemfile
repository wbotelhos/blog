source :rubygems

gem 'mysql2'
gem 'pygments.rb'
gem 'rails', '3.2.9'
gem 'redcarpet'
gem 'thinking-sphinx'

group :development do
  gem 'awesome_print', require: false
  gem 'capistrano'
  gem 'mailcatcher'
  gem 'pry',           require: false
end

group :development, :test do
  gem 'capybara', '~> 1.1.3'
  gem 'database_cleaner'
  gem 'rspec-rails', '~> 2.12.0'
end

group :test do
  gem 'factory_girl', '~> 4.1.0'
end

group :production do
  gem 'unicorn'
end
