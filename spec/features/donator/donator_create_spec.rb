# coding: utf-8
require 'spec_helper'

describe Donator, '#create' do
  let(:user) { FactoryGirl.create :user }
  let(:donator) { FactoryGirl.build :donator }

  before do
    login with: user.email
    visit donators_new_path
  end

  context 'submit with valid data' do
    before do
      fill_in 'donator_name', with: donator.name
      fill_in 'donator_email', with: donator.email
      fill_in 'donator_amount', with: donator.amount
      click_button 'Salvar'
    end

    it { current_path.should == '/donators' }

    it { page.should have_content 'Doador criado com sucesso!' }
  end

  context 'with invalid data' do
    context 'blank name' do
      before do
        fill_in 'donator_name', with: ''
        click_button 'Salvar'
      end

      it 'renders form page again' do
        current_path.should == donators_path
      end

      it { page.should have_content 'O campo "Nome *" deve ser preenchido!' }
    end

    context 'blank e-mail' do
      before do
        fill_in 'donator_name', with: donator.name
        fill_in 'donator_amount', with: donator.amount
        fill_in 'donator_email', with: ''
        click_button 'Salvar'
      end

      it 'renders form page again' do
        current_path.should == donators_path
      end

      it { page.should have_content 'O campo "E-mail *" deve ser preenchido!' }
    end

    context 'putting text in amount field' do
      before do
        fill_in 'donator_name', with: donator.name
        fill_in 'donator_email', with: donator.email
        fill_in 'donator_amount', with: 'not-a-number'
        click_button 'Salvar'
      end

      it 'renders form page again' do
        current_path.should == donators_path
      end

      it { page.should have_content 'O valor "not-a-number" não é um número válido para o campo "Valor *"!' }
    end
  end
end
