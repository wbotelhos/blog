# coding: utf-8
require 'spec_helper'

describe Article, '#update' do
  let(:user) { FactoryGirl.create :user }
  let!(:category_1) { FactoryGirl.create :category }
  let!(:category_2) { FactoryGirl.create :category }
  let(:article) { FactoryGirl.create :article, categories: [category_1] }

  before do
    login with: user.email
    visit articles_edit_path article
  end

  context 'with valid data' do
    before do
      fill_in 'article_title', with: 'title-new'
      fill_in 'article_body', with: 'body-new'
      check category_1.name
      click_button 'Atualizar'
    end

    it 'redirects to edit page' do
      current_path.should == "/articles/#{article.id}/edit"
    end

    it 'displays success message' do
      page.should have_content 'Artigo atualizado com sucesso!'
    end

    it { find_field('article_title').value.should == 'title-new' }
    it { find_field('article_body').value.should == 'body-new' }
    it { find_field(category_1.name).should be_checked }
  end

  context 'with invalid data' do
    before do
      fill_in 'article_title', with: ''
      click_button 'Atualizar'
    end

    it 'renders form page again' do
      current_path.should == "/articles/#{article.id}"
    end

    it 'the chosen category keeps checked' do
      page.should have_checked_field "category-#{category_1.id}"
    end

    context 'blank title' do
      before do
        fill_in 'article_title', with: ''
        check category_1.name
        click_button 'Atualizar'
      end

      it { page.should have_content 'O campo "Título *" deve ser preenchido!' }
    end

    context 'with blank title the slug message validation is skipped' do
      before do
        fill_in 'article_title', with: ''
        check category_1.name
        click_button 'Atualizar'
      end

      it { page.should_not have_content 'O campo "Slug" deve ser preenchido!' }
    end

    context 'blank category' do
      before do
        fill_in 'article_title', with: 'title'
        uncheck category_1.name
        uncheck category_2.name
        click_button 'Atualizar'
      end

      it { page.should have_content 'O campo "Categoria" deve ser preenchido!' }
    end
  end
end
