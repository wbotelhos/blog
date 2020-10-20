# frozen_string_literal: true

RSpec.describe UsersController do
  context 'accessing the admin area' do
    context 'unlogged' do
      it 'redirect to the login page' do
        get :edit, params: { id: 1 }
        expect(response).to redirect_to login_path
      end

      it 'redirect to the login page' do
        get :update, params: { id: 1 }
        expect(response).to redirect_to login_path
      end
    end
  end
end
