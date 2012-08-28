require "spec_helper"

describe LabsController do

  context "accessing the labs" do
    context "when unlogged" do
      it "redirect to the page" do
        get :index
        response.should redirect_to(labs_path)
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

      it "redirect to the page" do
        get :index
        response.should redirect_to(labs_path)
      end
    end
  end

end
