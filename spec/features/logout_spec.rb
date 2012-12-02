require 'spec_helper'

describe "Logout" do
  let(:user) { FactoryGirl.create :user }

  context "when logout" do
    context "via top link" do
      before do
        login with: user.email
        visit root_path
        find('#top nav ul').click_link 'Sair'
      end

      it "redirects to the home page" do
        current_path.should == root_path
      end

      it { page.should have_no_content 'Admin!' }
      it { page.should have_no_content 'Sair' }
    end

    context "via bottom link" do
      before do
        login with: user.email
        visit root_path
        find('#administration').click_link 'Sair'
      end

      it "redirects to the home page" do
        current_path.should == root_path
      end

      it { page.should have_no_content 'Admin!' }
      it { page.should have_no_content 'Sair' }
    end
  end
end
