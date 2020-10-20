# frozen_string_literal: true

require 'rack_session_access/capybara'

module LoginHelper
  def login(user)
    page.set_rack_session(user_id: user.id)

    user
  end

  def logout
    page.set_rack_session(user_id: nil)
  end
end

RSpec.configure do |config|
  config.include(LoginHelper, type: :feature)
end
