# frozen_string_literal: true

RSpec.describe AdminController do
  context 'accessing the admin area' do
    context 'unlogged' do
      it 'redirect to the login page' do
        get :index
        expect(response).to redirect_to login_url
      end
    end
  end
end
