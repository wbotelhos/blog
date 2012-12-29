# coding: utf-8
require 'spec_helper'

describe Category, '#new' do
  context 'when logged' do
    let(:user) { FactoryGirl.create :user }

    before do
      login with: user.email
      visit admin_path
      find('.category-menu').click_link 'Criar'
    end

    context 'page' do
      it { current_path.should == '/categories/new' }

      it 'display title' do
        find('#title h2').should have_content 'Nova Categoria'
      end
    end

    context 'form' do
      it { current_path.should == '/categories/new' }

      it { page.should have_field 'category_name' }
      it { page.should have_button 'Salvar' }
    end
  end

  context 'when unlogged' do
    before { visit categories_new_path }

    it 'redirects to the login page' do
      current_path.should == login_path
    end

    it 'displays error message' do
      page.should have_content 'Você precisa estar logado!'
    end
  end
end
