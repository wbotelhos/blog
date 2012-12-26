# coding: utf-8
require 'spec_helper'

describe Donator, '#update' do
  let(:user) { FactoryGirl.create :user }
  let(:donator) { FactoryGirl.create :donator }

  before do
    login with: user.email
    visit donators_edit_path donator
  end

  context 'with valid data' do
    before do
      fill_in 'donator_name', with: 'name-new'
      fill_in 'donator_amount', with: 20
      click_button 'Atualizar'
    end

    it 'redirects to index page' do
      current_path.should == '/donators'
    end

    it 'displays success message' do
      page.should have_content 'Doador atualizado com sucesso!'
    end

    it { find('.name').should have_link 'name-new' }
    it { find('.amount').should have_content 20 }
  end
end
