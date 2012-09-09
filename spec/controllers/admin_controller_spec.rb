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
      xit "redirect to the login page" do
        get :index, :id => 1
        assert_response :success
      end
    end
  end
end
