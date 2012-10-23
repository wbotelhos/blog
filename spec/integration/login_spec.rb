# coding: utf-8
require 'spec_helper'

describe "Login" do
  let(:user) { FactoryGirl.create :user }

  before do
    visit login_path

    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: 'password'
    click_button 'Acessar'
  end

  it "should disapear the login link" do
    current_path.should == root_path
  end
end
