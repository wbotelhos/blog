module IntegrationHelper
  def login(options)
    visit login_path

    fill_in 'E-mail', with: options[:with]
    fill_in 'Senha', with: 'password'

    click_button 'Acessar'
  end
end

RSpec.configure do |config|
  config.include(IntegrationHelper, type: :request)
end
