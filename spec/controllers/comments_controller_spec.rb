require 'rails_helper'

describe CommentsController do
  context 'accessing the admin area' do
    context 'unlogged' do
      it 'redirect to the login page' do
        get :edit, article_id: 1, id: 1
        expect(response).to redirect_to login_path
      end

      it 'redirect to the login page' do
        put :update, article_id: 1, id: 1
        expect(response).to redirect_to login_path
      end
    end
  end
end
