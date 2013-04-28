# coding: utf-8
require 'spec_helper'

describe 'top' do
  context 'static data' do
    before { visit '/' }

    it 'should show logo data' do
      page.should have_content CONFIG['author']
      page.should have_content CONFIG['description']
    end
  end

  context 'when logged' do
    let(:user) { FactoryGirl.create :user }

    before { login with: user.email }

    it 'should show menu' do
      page.should have_content 'Sobre'
      page.should have_content 'Admin!'
      page.should have_content 'Sair'
    end
  end
end
