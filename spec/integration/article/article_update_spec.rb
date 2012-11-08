# coding: utf-8
require 'spec_helper'

describe Article, "#update" do
  let(:user) { FactoryGirl.create :user }
  let!(:category_1) { FactoryGirl.create :category }
  let!(:category_2) { FactoryGirl.create :category }
  let(:article) { FactoryGirl.create :article, categories: [category_1] }

  before do
    login with: user.email
    visit edit_article_path(article)
  end

  context "submit with valid data" do
    before do
      fill_in 'article_title', with: 'title-new'
      fill_in 'article_body', with: 'body-new'
      uncheck "category-#{category_1.id.to_s}"
      check "category-#{category_2.id.to_s}"
      click_button 'Atualizar'
    end

    it "redirects to edit page" do
      current_path.should == "/articles/#{article.id}/edit"
    end

    it "displays success message" do
      page.should have_content 'Artigo atualizado com sucesso!'
    end

    it { find_field('article_title').value.should == 'title-new' }
    it { find_field('article_body').value.should == 'body-new' }
    it { find_field("category-#{category_2.id.to_s}").should be_checked }
  end

  context "with invalid data" do
    before do
      fill_in 'article_title', with: ''
      check "category-#{category_1.id.to_s}"
      click_button 'Atualizar'
    end

    it "renders edit form page again" do
      current_path.should == edit_article_path(article)
    end

    it "the chosen category keeps checked" do
      page.should have_checked_field "category-#{category_1.id.to_s}"
    end

    context "blank title" do
      before do
        @title = article.title

        fill_in 'article_title', with: ''
        check "category-#{category_1.id.to_s}"
        click_button 'Atualizar'
      end

      it "displays success message" do
        page.should have_content 'Artigo atualizado com sucesso!'
      end

      it "keeps the original one by validation" do
        find_field('article_title').value.should == @title
      end
    end

    context "blank category" do
      before do
        fill_in 'article_title', with: 'title'
        uncheck "category-#{category_1.id.to_s}"
        uncheck "category-#{category_2.id.to_s}"
        click_button 'Atualizar'
      end

      it "displays success message" do
        page.should have_content 'Artigo atualizado com sucesso!'
      end

      it "keeps the original one by validation" do
        find_field("category-#{category_1.id.to_s}").should be_checked
      end
    end

    context "blank body" do
      before do
        fill_in 'article_title', with: 'title'
        fill_in 'article_body', with: ''
        check "category-#{category_1.id.to_s}"
        click_button 'Atualizar'
      end

      it "displays success message" do
        page.should have_content 'Artigo atualizado com sucesso!'
      end

      it "set the blank value" do
        find_field('article_body').value.should be_empty
      end
    end
  end
end
