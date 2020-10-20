require 'rails_helper'

describe ArticlesController do
  context 'accessing the admin area' do
    context 'unlogged' do
      it 'redirect to the login page' do
        get :new
        expect(response).to redirect_to login_url
      end

      it 'redirect to the login page' do
        get :edit, params: { id: 1 }
        expect(response).to redirect_to login_url
      end

      it 'redirect to the login page' do
        put :update, params: { id: 1 }
        expect(response).to redirect_to login_url
      end

      it 'redirect to the login page' do
        post :create
        expect(response).to redirect_to login_url
      end
    end
  end
end
