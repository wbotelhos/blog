# frozen_string_literal: true

RSpec.describe LabsController do
  context 'accessing the admin area' do
    context 'unlogged' do
      it 'redirect to the login page' do
        post :create
        expect(response).to redirect_to login_path
      end

      it 'redirect to the login page' do
        get :edit, params: { id: 1 }
        expect(response).to redirect_to login_path
      end

      it 'redirect to the login page' do
        get :export, params: { id: 1 }
        expect(response).to redirect_to login_path
      end

      it 'redirect to the login page' do
        get :new
        expect(response).to redirect_to login_path
      end

      it 'redirect to the login page' do
        put :update, params: { id: 1 }
        expect(response).to redirect_to login_path
      end
    end
  end
end
