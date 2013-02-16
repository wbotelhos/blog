# coding: utf-8
require 'spec_helper'

describe User, 'session#new' do
  let(:user) { FactoryGirl.create :user }

  before { visit login_path }

  context 'with wrong password' do
    before do
      fill_in 'email', with: 'invalid@mail.com'
      fill_in 'password', with: 'wrong-password'
      uncheck 'bot'
      click_button 'Acessar'
    end

    it 'redirects to the same page' do
      current_path.should == login_path
    end

    it 'displays error message' do
      within '#container-login' do
        page.should have_content 'E-mail ou senha inválida!'
      end
    end
  end

  context 'with right password' do
    before do
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      uncheck 'bot'
      click_button 'Acessar'
    end

    it 'redirects to admin page' do
      current_path.should == admin_path
    end
  end

  context 'anti bot', js: true do
    it 'starts checked' do
      find('#bot').should be_checked
    end

    it 'starts with bot log' do
      find('#human label').should have_content 'b0t?'
    end

    context 'on uncheck' do
      before { uncheck 'bot' }

      it 'log human message' do
        find('#human label').should have_content 'human! <3'
      end

      context 'on check' do
        before { check 'bot' }

        it 'log human message' do
          find('#human label').should have_content 'stupid! :/'
        end

        context 'and submit' do
          before { click_button 'Acessar' }

          it 'blocks and log looser message' do
            find('#human label').should have_content 'b0t? l00s3r!'
          end
        end
      end
    end
  end

  context 'when logged' do
    before do
      login with: user.email
      visit login_path
    end

    context 'and visit login page' do
      it 'redirects to index page' do
        current_path.should == root_path
      end
    end
  end
end
