require "spec_helper"

describe AdminController do

  context "accessing the admin area" do
    context "when unlogged" do
      it "redirect to the login page" do
        get :index
        response.should redirect_to(login_path)
      end
    end

    context "when logged" do
      let!(:user) { FactoryGirl.create(:user) }

      before do
        @user = mock("user")
        @user.stub :email => "wbotelhos@gmail.com"
        @user.stub :password => "test"
        login :with => @user.email
      end

      it "redirect to the login page" do
        get :index
        response.should redirect_to(admin_path)
      end
    end
  end

end
