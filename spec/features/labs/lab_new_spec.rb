# coding: utf-8
require 'spec_helper'

describe Lab, "#new" do
  context "when logged" do
    let(:user) { FactoryGirl.create :user }
    let!(:category_1) { FactoryGirl.create :category, name: 'category-1' }
    let!(:category_2) { FactoryGirl.create :category, name: 'category-2' }
    let!(:category_3) { FactoryGirl.create :category, name: 'category-3' }

    before do
      login with: user.email
      visit admin_path
      find('.lab-menu').click_link 'Criar'
    end

    context "page" do
      it { current_path.should == '/labs/new' }

      it "display title" do
        page.find('#title h2').should have_content 'Novo Projeto'
      end
    end

    context "form" do
      it { current_path.should == '/labs/new' }

      it { page.should have_field 'lab_name' }
      it { page.should have_field 'lab_slug' }
      it { page.should have_field 'lab_description' }
      it { page.should have_field 'lab_image' }
      it { page.should have_button 'Salvar' }
      it { page.should have_button 'Publicar' }
    end
  end

  context "when unlogged" do
    before { visit labs_new_path }

    it "redirects to the login page" do
      current_path.should == login_path
    end

    it "displays error message" do
      page.should have_content 'Você precisa estar logado!'
    end
  end
end
