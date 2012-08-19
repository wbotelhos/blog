require "spec_helper"

# TODO: the selectors are ignored and always are GREEN. :/

describe "users/new.html.erb" do
  it "render form to create a user" do
    assign :user, mock_model("User").as_new_record.as_null_object

    render

    rendered.should have_selector("form", :method => "post", :action => create_user_path) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "render a text field for the user name" do
    assign :user, mock_model("User", :name => "name").as_new_record

    render

    rendered.should have_selector("form") do |form|
      form.should have_selector("input",
        :type => "text",
        :name => "user[name]",
        :value => "name"
      )
    end
  end
end
