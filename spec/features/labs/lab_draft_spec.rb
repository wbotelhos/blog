# coding: utf-8
require 'spec_helper'

describe Lab, "#index" do
  let(:user) { FactoryGirl.create :user }

  context "when logged" do
    before do
      login with: user.email
      visit labs_drafts_path
    end

    context "with record" do
      let!(:lab_published) { FactoryGirl.create :lab_published }
      let!(:lab_draft) { FactoryGirl.create :lab_draft }

      before { visit labs_drafts_path }

      it "do not display published record" do
        page.should have_no_content lab_published.name
      end

      it "display the draft record" do
        page.find('.name').should have_link lab_draft.name, href: lab_draft.site
        page.find('.description').should have_content lab_draft.description
        page.find('.image a img').should have_content lab_draft.image
      end

      it "show github's link" do
        page.find('.links').should have_link '', href: lab_draft.github
      end

      it "show site's link" do
        page.find('.links').should have_link '', href: lab_draft.site
      end

      it "show edit link" do
        page.find('.links').should have_link '', href: labs_edit_path(lab_draft)
      end
    end

    context "without record" do
      before { visit labs_drafts_path }

      it "access index page" do
        current_path.should == '/labs/drafts'
      end

      it "show no result message" do
        page.should have_content 'Nenhum projeto publicado!'
      end
    end
  end

  context "when unlogged" do
    before { visit labs_drafts_path }

    it "redirects to the login page" do
      current_path.should == login_path
    end

    it "displays error message" do
      page.should have_content 'Você precisa estar logado!'
    end
  end
end
