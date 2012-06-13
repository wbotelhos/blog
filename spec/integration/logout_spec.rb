require "spec_helper"

describe "Logout" do

  context "when logout" do
    let!(:user) { FactoryGirl.create(:user) }

    before do
      login :with => user.email
      visit "/"
      click_link "Sair"
    end

    it { page.should_not have_content("Admin") }
    it { page.should_not have_content("Sair") }

    it "redirects to the home page" do
      current_path.should eql(root_path)
    end
  end

end
