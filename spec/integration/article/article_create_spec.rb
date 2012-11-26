# coding: utf-8
require 'spec_helper'

describe Article, "#create" do
  let(:user) { FactoryGirl.create :user }
  let!(:category) { FactoryGirl.create :category }

  before do
    login with: user.email
    visit new_article_path
  end

  context "submit with valid data" do
    before do
      fill_in 'article_title', with: 'title'
      fill_in 'article_body', with: 'body'
      check "category-#{category.id.to_s}"
      click_button 'Salvar'
    end

    it "redirects to edit page" do
      current_path.should match %r(/articles/\d+/edit)
    end

    it "displays success message" do
      page.should have_content 'Rascunho salvo com sucesso!'
    end
  end

  context "with invalid data" do
    before do
      fill_in 'article_title', with: ''
      check "category-#{category.id.to_s}"
      click_button 'Salvar'
    end

    it "renders form page again" do
      current_path.should == create_article_path
    end

    it "the chosen category keeps checked" do
      page.should have_checked_field "category-#{category.id.to_s}"
    end

    context "blank title" do
      before do
        fill_in 'article_title', with: ''
        check "category-#{category.id.to_s}"
        click_button 'Salvar'
      end

      it { page.should have_content 'O campo "Título" deve ser preenchido!' }
    end

    context "blank category" do
      before do
        fill_in 'article_title', with: 'title'
        uncheck "category-#{category.id.to_s}"
        click_button 'Salvar'
      end

      it { page.should have_content 'O campo "Categoria" deve ser preenchido!' }
    end

    context "blank body" do
      before do
        fill_in 'article_title', with: 'title'
        fill_in 'article_body', with: ''
        check "category-#{category.id.to_s}"
        click_button 'Salvar'
      end

      it "redirects to edit page" do
        current_path.should match %r(/articles/\d+/edit)
      end

      it "displays success message" do
        page.should have_content 'Rascunho salvo com sucesso!'
      end
    end
  end
end
