module SessionHelper
  def login(options)
    visit login_path unless current_path == login_path

    fill_in 'E-mail', with: options[:with]
    fill_in 'Senha', with: options[:password] || 'password'
    uncheck 'bot'

    click_button 'Acessar'
  end
end

RSpec.configure do |config|
  config.include SessionHelper, type: :feature
end
