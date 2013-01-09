# coding: utf-8
require 'spec_helper'

describe Category, '#edit' do
  let!(:category) { FactoryGirl.create :category, name: 'Skate' }

  context "visiting the root page" do
    before { visit root_path }

    it "show edit link on category line" do
      page.should have_link 'Edit', href: categories_edit_path(category.id)
    end
  end

  context 'when logged' do
    let(:user) { FactoryGirl.create :user }

    before { login with: user.email }

    context 'page' do
      before { visit categories_edit_path category }

      it { current_path.should == "/categories/#{category.id}/edit" }

      it 'display title' do
        find('#title h2').should have_content 'Editar Categoria'
      end
    end

    context 'form' do
      before { visit categories_edit_path category }

      it { find('#category_name').value.should == category.name }
      it { page.should have_button 'Atualizar' }
    end
  end

  context 'when unlogged' do
    before { visit categories_edit_path category.id }

    it 'redirects to the login page' do
      current_path.should == login_path
    end

    it 'displays error message' do
      page.should have_content 'Você precisa estar logado!'
    end
  end
end
