# coding: utf-8
require 'spec_helper'

describe Lab, "#create" do
  let(:user) { FactoryGirl.create :user }

  before do
    login with: user.email
    visit labs_new_path
  end

  context "submit with valid data" do
    before do
      fill_in 'lab_name', with: 'name'
      fill_in 'lab_slug', with: 'slug'
      fill_in 'lab_description', with: 'description'
      fill_in 'lab_image', with: 'image'
      click_button 'Salvar'
    end

    it "redirects to drafts page" do
      current_path.should == '/labs/drafts'
    end

    it "displays success message" do
      page.should have_content 'Rascunho salvo com sucesso!'
    end
  end

  context "with invalid data" do
    context "blank name" do
      before do
        fill_in 'lab_name', with: ''
        click_button 'Salvar'
      end

      it "renders form page again" do
        current_path.should == labs_path
      end

      it { page.should have_content 'O campo "Nome *" deve ser preenchido!' }
    end

    context "blank slug" do
      before do
        fill_in 'lab_name', with: 'name'
        fill_in 'lab_slug', with: ''
        click_button 'Salvar'
      end

      it "renders form page again" do
        current_path.should == labs_path
      end

      it { page.should have_content 'O campo "Slug *" deve ser preenchido!' }
    end

    context "Name already taken" do
      let!(:lab) { FactoryGirl.create :lab }

      before do
        fill_in 'lab_name', with: lab.name
        fill_in 'lab_slug', with: 'new-slug'
        click_button 'Salvar'
      end

      it "renders form page again" do
        current_path.should == labs_path
      end

      it { page.should have_content %(O valor "#{lab.name}" para o campo "Nome *" já esta em uso!) }
    end
  end
end
