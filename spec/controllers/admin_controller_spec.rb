require "spec_helper"

describe AdminController do

  context "access when unlogged" do
    it "redirects to the login page" do
      get :index
      response.should redirect_to(login_path)
    end
  end

end
