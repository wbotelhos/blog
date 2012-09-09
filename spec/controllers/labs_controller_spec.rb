require "spec_helper"

describe LabsController do
  context "GET #drafts" do
    context "when unlogged" do
      it "redirect to login page" do
        get :drafts
        response.should redirect_to(login_path)
      end

      it "shows mandatory login message"
    end

    context "when logged" do
      before do
        @user = mock("user")
        @user.stub(:id).and_return(1)
      end

      xit "redirect to the page" do
        get :drafts, {}, { :user_id => @user.id }
        assert_response :success
      end
    end
  end
end
