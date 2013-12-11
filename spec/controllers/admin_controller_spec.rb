require 'spec_helper'

describe AdminController do
  context 'accessing the admin area' do
    context :unlogged do
      it 'redirect to the login page' do
        get :index
        response.should redirect_to login_path
      end
    end
  end
end
