# coding: utf-8
require 'spec_helper'

describe Lab, "#index" do
  let(:user) { FactoryGirl.create :user }

  context "with records without image" do
    let!(:lab_published) { FactoryGirl.create :lab_published, image: nil }
    let!(:lab_draft) { FactoryGirl.create :lab_draft }

    before { visit labs_path }

    it "do not display draft record" do
      page.should have_no_content lab_draft.name
    end

    it "display the published record" do
      find('.name').should have_link lab_published.name, href: lab_published.site
      find('.description').should have_content lab_published.description
      find('.image a').should have_content lab_published.image
      find('.image a').should_not have_selector 'img'
    end

    it "show github's link" do
      find('.links').should have_link '', href: lab_published.github
    end

    it "show site's link" do
      find('.links').should have_link '', href: lab_published.site
    end

    context "when logged" do
      before do
        login with: user.email
        visit labs_path
      end

      it "show edit link" do
        find('.links').should have_link '', href: labs_edit_path(lab_published)
      end
    end

    context "when unlogged" do
      it "hide edit link" do
        page.should have_no_selector '.lab:first .info .links .edit'
      end
    end
  end

  context "with record with image" do
    let!(:lab) { FactoryGirl.create :lab_published, image: 'http://url.com/image.jpg' }

    before { visit labs_path }

    it "display a imagem" do
      find('.image a img')['src'].should == lab.image
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
