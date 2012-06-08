require "spec_helper"

describe "Logout" do

  context "when logged in" do
    let!(:user) { users(:user) }

    before do
      login :with => user.email
      visit "/"
      click_link "Sair"
    end

    it "redirects to the home page" do
      current_path.should eql(root_path)
    end

    it "omits the admin menu" do
      page.should_not have_content("Admin!")
    end
  end

  context "when unlogged" do
    before do
      visit logout_path
    end

    it "redirects to the home page" do
      current_path.should eql(root_path)
    end

    it "should hide sair link" do
      page.should_not have_content("Sair")
    end
  end

end
