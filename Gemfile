source :rubygems

gem "rails", "3.2.7"
gem "mysql2"
gem "thinking-sphinx"
gem "redcarpet"
gem "pygments.rb"

group :development do
  gem "pry", :require => false
  gem "awesome_print", :require => false
  gem "mailcatcher"
  gem "capistrano"
end

group :development, :test do
  gem "rspec-rails"
  gem "capybara"
  gem "database_cleaner"
end

group :test do
  gem "factory_girl"
end

group :production do
  gem "unicorn"
end
