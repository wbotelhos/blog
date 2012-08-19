require "spec_helper"

describe "users/about.html.erb" do
  it "displays the author bio" do
    assign :author, mock_model("User", :bio => "bio").as_null_object
    render
    rendered.should include("bio")
  end

  it "displays the author name" do
    assign :author, mock_model("User", :name => "name").as_null_object
    render
    rendered.should include("name")
  end
end
