# coding: utf-8
require 'spec_helper'

describe Donator, '#new' do
  context 'when logged' do
    let(:user) { FactoryGirl.create :user }
    let!(:donator) { FactoryGirl.create :donator }

    before do
      login with: user.email
      visit admin_path
      find('.donator-menu').click_link 'Criar'
    end

    context 'page' do
      it { current_path.should == '/donators/new' }

      it 'display title' do
        find('#title h2').should have_content 'Novo Doador'
      end
    end

    context 'form' do
      it { current_path.should == '/donators/new' }

      it { page.should have_field 'donator_name' }
      it { page.should have_field 'donator_email' }
      it { page.should have_field 'donator_url' }
      it { page.should have_field 'donator_amount' }
      it { page.should have_field 'donator_about' }
      it { page.should have_field 'donator_country' }
      it { page.should have_field 'donator_message' }
      it { page.should have_button 'Salvar' }
    end
  end

  context 'when unlogged' do
    before { visit donators_new_path }

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
