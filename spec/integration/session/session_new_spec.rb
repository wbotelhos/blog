# coding: utf-8
require 'spec_helper'

describe User, 'session#new' do
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
    let(:user) { FactoryGirl.create :user }

    before do
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Acessar'
    end

    it 'redirects to the same page' do
      current_path.should == root_path
    end

    it "displays error message" do
      page.should_not have_content 'E-mail ou senha inválida!'
    end
  end

  # TODO: Jasmine
  context "with anti bot checked" do
  end
end
