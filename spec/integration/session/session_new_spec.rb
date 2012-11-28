# coding: utf-8
require 'spec_helper'

describe User, 'session#new' do
  let(:user) { FactoryGirl.create :user }

  before { visit login_path }

  context "with wrong password" do
    before do
      fill_in 'email', with: 'invalid@mail.com'
      fill_in 'password', with: 'wrong-password'
      click_button 'Acessar'
    end

    it 'redirects to the same page' do
      current_path.should == login_path
    end

    it "displays error message" do
      page.should have_content 'E-mail ou senha inválida!'
    end
  end

  context "with right password" do
    before do
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Acessar'
    end

    it 'redirects to the same page' do
      current_path.should == root_path
    end

    it "displays error message" do
      page.should have_no_content 'E-mail ou senha inválida!'
    end
  end

  context "when logged" do
    before do
      login with: user.email
      visit login_path
    end

    context "and visit login page" do
      it 'redirects to index page' do
        current_path.should == root_path
      end
    end
  end
end
