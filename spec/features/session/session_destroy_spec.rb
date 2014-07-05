require 'rails_helper'

describe User do
  before do
    login
    visit admin_path
  end

  it 'starts with user access' do
    expect(current_path).to eq admin_path
  end

  context 'when logout' do
    before { click_link '', href: '/logout' }

    it 'redirects to the home page' do
      expect(current_path).to eq root_path
    end

    context 'trying to access admin' do
      before { visit admin_path }

      it 'losts the admin access' do
        expect(current_path).to eq login_path
      end
    end
  end
end
