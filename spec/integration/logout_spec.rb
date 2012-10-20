require 'spec_helper'

describe "Logout" do
  let(:user) { FactoryGirl.create(:user, id: 1) }

  context "when logout" do
    before do
      login with: user.email
      visit "/"
      click_link "Sair"
    end

    it "redirects to the home page" do
      current_path.should eql(root_path)
    end

    it { page.should_not have_content("Admin!") }
    it { page.should_not have_content("Sair") }
  end

end
