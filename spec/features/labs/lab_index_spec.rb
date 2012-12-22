# coding: utf-8
require 'spec_helper'

describe Lab, "#index" do
  let(:user) { FactoryGirl.create :user }

  context "with records" do
    let!(:lab_published) { FactoryGirl.create :lab_published }
    let!(:lab_draft) { FactoryGirl.create :lab_draft }

    before { visit labs_path }

    it "do not display draft record" do
      page.should have_no_content lab_draft.name
    end

    it "display the published record" do
      page.find('.name').should have_link lab_published.name, href: lab_published.site
      page.find('.description').should have_content lab_published.description
      page.find('.image a img').should have_content lab_published.image
    end

    it "show github's link" do
      page.find('.links').should have_link '', href: lab_published.github
    end

    it "show site's link" do
      page.find('.links').should have_link '', href: lab_published.site
    end

    context "when logged" do
      before do
        login with: user.email
        visit labs_path
      end

      it "show edit link" do
        page.find('.links').should have_link '', href: labs_edit_path(lab_published)
      end
    end

    context "when unlogged" do
      it "hide edit link" do
        page.should have_no_selector '.lab:first .info .links .edit'
      end
    end
  end

  context "without record" do
    before { visit labs_path }

    it "access index page" do
      current_path.should == '/labs'
    end

    it "show no result message" do
      page.should have_content 'Nenhum projeto publicado!'
    end
  end
end