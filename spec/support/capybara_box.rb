# frozen_string_literal: true

require 'capybara/rails'
require 'capybara-box'

Capybara.disable_animation = true

ci = Helper.true?(ENV['CI'])

CapybaraBox::Base.configure(
  browser:    ENV.fetch('BROWSER', :selenium_chrome_headless).to_sym,
  log:        !ci,
  screenshot: { enabled: ci, s3: ci },
  version:    ENV['CHROMEDRIVER_VERSION']
)
