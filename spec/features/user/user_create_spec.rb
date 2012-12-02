# coding: utf-8
require 'spec_helper'

describe User, '#create' do
  context 'when logged' do
    let(:user) { FactoryGirl.create :user }
    let(:category) { FactoryGirl.create :category }

    before do
      login with: user.email
      click_link 'Admin!'
      find('.user-menu').click_link 'Criar'
    end

    it 'redirects to new page' do
      current_path.should == '/users/new'
    end
  end
end
