# coding: utf-8
require 'spec_helper'

describe Donator, "#update" do
  let(:user) { FactoryGirl.create :user }
  let!(:category_1) { FactoryGirl.create :category }
  let!(:category_2) { FactoryGirl.create :category }
  let(:donator) { FactoryGirl.create :donator, categories: [category_1] }

  before do
    login with: user.email
    visit donators_edit_path donator
  end

  context "with valid data" do
    before do
      fill_in 'donator_title', with: 'title-new'
      fill_in 'donator_body', with: 'body-new'
      uncheck "category-#{category_1.id}"
      check "category-#{category_2.id}"
      click_button 'Atualizar'
    end

    it "redirects to edit page" do
      current_path.should == "/donators/#{donator.id}/edit"
    end

    it "displays success message" do
      page.should have_content 'Artigo atualizado com sucesso!'
    end

    it { find_field('donator_title').value.should == 'title-new' }
    it { find_field('donator_body').value.should == 'body-new' }
    it { find_field("category-#{category_2.id}").should be_checked }
  end

  context "with invalid data" do
    before do
      fill_in 'donator_body', with: ''
      click_button 'Atualizar'
    end

    it "renders edit form page again" do
      current_path.should == donators_edit_path(donator)
    end

    it "the chosen category keeps checked" do
      page.should have_checked_field "category-#{category_1.id}"
    end

    context "given blank title" do
      before do
        fill_in 'donator_title', with: ''
        click_button 'Atualizar'
      end

      it "displays success message" do
        page.should have_content 'Artigo atualizado com sucesso!'
      end

      it "keeps the original one by validation" do
        find_field('donator_title').value.should == donator.title
      end
    end

    context "given blank category" do
      before do
        uncheck "category-#{category_1.id}"
        click_button 'Atualizar'
      end

      it "displays success message" do
        page.should have_content 'Artigo atualizado com sucesso!'
      end

      it "keeps the original one by validation" do
        find_field("category-#{category_1.id}").should be_checked
      end
    end

    context "given blank body" do
      before do
        fill_in 'donator_body', with: ''
        click_button 'Atualizar'
      end

      it "displays success message" do
        page.should have_content 'Artigo atualizado com sucesso!'
      end

      it "set the blank value" do
        find_field('donator_body').value.should be_empty
      end
    end
  end
end
