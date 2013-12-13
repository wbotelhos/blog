require 'rack_session_access/capybara'

module SessionHelper
  def login
    user = FactoryGirl.create :user

    page.set_rack_session current_user: user.id
  end

  def logout
    page.set_rack_session current_user: nil
  end
end

RSpec.configure do |config|
  config.include SessionHelper, type: :feature
end
