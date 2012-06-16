# coding: utf-8
require "spec_helper"

describe "About" do
  let!(:user) { FactoryGirl.create(:user, :id => 1) }

  context "profile display" do
    before do
      visit about_path
    end

    it "should redirects to the about page" do
      current_path.should eql(about_path)
    end

     xit "should show the author's bio" do
       page.should have_content("Desenvolvedor Java, Ruby e Python no Portal <a href=\"http://r7.com\" target=\"_blank\">R7.com</a>.")
     end
  end

end
