require 'rack_session_access/capybara'

module SessionHelper
  def login
    user = FactoryGirl.create :user

    page.set_rack_session user_id: user.id

    user
  end

  def logout
    page.set_rack_session user_id: nil
  end
end

RSpec.configure do |config|
  config.include SessionHelper, type: :feature
end
