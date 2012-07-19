source :rubygems

ruby "1.9.3"

gem "heroku", "2.28.15"
gem "rails", "3.2.6"
gem "thinking-sphinx"
gem "unicorn"
gem "redcarpet"
gem "pygments.rb"

group :development do
  gem "pry", :require => false
  gem "awesome_print", :require => false
  gem "mailcatcher"
  gem "capistrano"
end

group :development, :test do
  gem "sqlite3"
  gem "rspec-rails"
  gem "capybara"
  gem "database_cleaner"
end

group :test do
  gem "factory_girl"
end

group :production do
  gem "pg"
  gem "thin"
end