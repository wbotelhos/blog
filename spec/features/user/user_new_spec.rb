# coding: utf-8
require 'spec_helper'

describe User, '#new' do
  context 'when logged' do
    let(:user) { FactoryGirl.create :user }

    before { login with: user.email }

    context 'page' do
      before do
        visit admin_path
        find('.user-menu').click_link 'Criar'
      end

      it { current_path.should == '/users/new' }

      it 'display title' do
        find('#title h2').should have_content 'Novo Usuário'
      end
    end

    context 'form' do
      before { visit users_new_path }

      it { page.should have_field 'user_name' }
      it { page.should have_field 'user_email' }
      it { page.should have_field 'user_bio' }
      it { page.should have_field 'user_url' }
      it { page.should have_field 'user_github' }
      it { page.should have_field 'user_linkedin' }
      it { page.should have_field 'user_twitter' }
      it { page.should have_field 'user_facebook' }
      it { page.should have_field 'user_password' }
      it { page.should have_field 'user_password_confirmation' }
    end
  end

  context 'when unlogged' do
    before { visit users_new_path }

    it 'redirects to the login page' do
      current_path.should == login_path
    end

    it 'displays error message' do
      within '#container-login' do
        page.should have_content 'Você precisa estar logado!'
      end
    end
  end
end
