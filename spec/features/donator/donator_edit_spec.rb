# coding: utf-8
require 'spec_helper'

describe Donator, '#edit' do
  let!(:category) { FactoryGirl.create :category }
  let!(:donator) { FactoryGirl.create :donator }

  context 'when logged' do
    let(:user) { FactoryGirl.create :user }

    before do
      login with: user.email
      visit donators_edit_path donator
    end

    context 'page' do
      it { current_path.should == "/donators/#{donator.id}/edit" }

      it 'display title' do
        find('#title h2').should have_content 'Editar Doador'
      end
    end

    context 'form' do
      # TODO: should have_field, text: xpto not work!
      it { find('#donator_name').value.should == donator.name }
      it { find('#donator_email').value.should == donator.email }
      it { find('#donator_url').value.should == donator.url }
      it { find('#donator_amount').value.should eq donator.amount.to_s }
      it { find('#donator_about').value.should == donator.about }
      it { find('#donator_country').value.should == donator.country }
      it { find('#donator_message').value.should == donator.message }
      it { page.should have_button 'Atualizar' }
    end
  end

  context 'when unlogged' do
    before { visit donators_edit_path donator.id }

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
