# coding: utf-8
require 'spec_helper'

describe Lab, "#new" do
  context "when logged" do
    let(:user) { FactoryGirl.create :user }
    let(:lab) { FactoryGirl.create :lab }

    before { login with: user.email }

    context "form" do
      before { visit labs_new_path }

      it { current_path.should == '/labs/new' }

      it { page.should have_field 'lab_name' }
      it { page.should have_field 'lab_slug' }
      it { page.should have_field 'lab_description' }
      it { page.should have_field 'lab_image' }
      it { page.should have_button 'Criar' }
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
