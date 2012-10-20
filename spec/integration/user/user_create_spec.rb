# coding: utf-8
require 'spec_helper'

describe User, '#create' do

  context 'when logged' do
    let(:user) { FactoryGirl.create :user }
    let(:category) { FactoryGirl.create :category }

    before do
      login with: user.email
      click_link 'Admin!'
      click_link 'new-user'
    end

    it 'redirects to new page' do
      current_path.should eql '/users/new'
    end
  end
end
