# coding: utf-8
require 'spec_helper'

describe Category, '#create' do
  let(:user) { FactoryGirl.create :user }

  before do
    login with: user.email
    visit categories_new_path
  end

  context 'submit with valid data' do
    before do
      fill_in 'category_name', with: 'name'
      click_button 'Salvar'
    end

    it 'redirects to root page' do
      current_path.should == '/'
    end

    it 'displays success message' do
      page.should have_content 'Categoria criada com sucesso!'
    end
  end

  context 'with invalid data' do
    context 'blank name' do
      before do
        fill_in 'category_name', with: ''
        click_button 'Salvar'
      end

      it 'renders form page again' do
        current_path.should == categories_path
      end

      it { page.should have_content 'O campo "Nome *" deve ser preenchido!' }
    end

    context 'Name already taken' do
      let!(:category) { FactoryGirl.create :category }

      before do
        fill_in 'category_name', with: category.name
        click_button 'Salvar'
      end

      it 'renders form page again' do
        current_path.should == categories_path
      end

      it { page.should have_content %(O valor "#{category.name}" para o campo "Nome *" já esta em uso!) }
    end
  end
end
