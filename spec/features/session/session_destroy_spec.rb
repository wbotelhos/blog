require 'rails_helper'

describe User do
  before do
    login
    visit admin_path
  end

  it 'starts with user access' do
    expect(page).to have_current_path admin_path, ignore_query: true
  end

  context 'when logout' do
    before { click_link '', href: '/logout' }

    it 'redirects to the home page' do
      expect(page).to have_current_path root_path, ignore_query: true
    end

    context 'trying to access admin' do
      before { visit admin_path }

      it 'losts the admin access' do
        expect(page).to have_current_path login_path, ignore_query: true
      end
    end
  end
end
