# coding: utf-8
require 'spec_helper'

describe Article, '#new' do
  context 'when logged' do
    let(:user) { FactoryGirl.create :user }
    let!(:category_1) { FactoryGirl.create :category, name: 'category-1' }
    let!(:category_2) { FactoryGirl.create :category, name: 'category-2' }
    let!(:category_3) { FactoryGirl.create :category, name: 'category-3' }

    before { login with: user.email }

    context 'page' do
      before do
        visit admin_path
        find('.article-menu').click_link 'Criar'
      end

      it { current_path.should == '/articles/new' }

      it 'display title' do
        find('#title h2').should have_content 'Novo Artigo'
      end
    end

    context 'form' do
      before { visit new_articles_path }

      it { current_path.should == '/articles/new' }

      it { page.should have_field 'article_title' }
      it { page.should have_field 'article_body' }
      it { page.should have_field "category-#{category_1.id}" }
      it { page.should have_field "category-#{category_2.id}" }
      it { page.should have_field "category-#{category_3.id}" }
      it { page.should have_button 'Salvar' }
      it { page.should have_button 'Publicar' }

      it 'displays all categories' do
        page.should have_content category_1.name
        page.should have_content category_2.name
        page.should have_content category_3.name
      end
    end
  end

  context 'when unlogged' do
    before { visit new_articles_path }

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
