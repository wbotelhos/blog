# -*- encoding: utf-8 -*-

require "spec_helper"

describe "Add comment" do
  let!(:user) { users(:user) }
  let!(:article) { articles(:article) }

  context "when logged in" do
    before do
      login :with => user.email
      visit article_path(article)
    end

    context "with valid data" do
      before do
        fill_in "comment_name", :with => "name"
        fill_in "comment_email", :with => "email@mail.com"
        fill_in "comment_url", :with => "http://url.com"
        fill_in "comment_body", :with => "comment"
        click_button "Comentar"
      end

      it "redirects to the article page" do
        current_path.should eql(article_path(article))
      end

       it "displays success message" do
         page.should have_content("Seu comentário foi adicionado!")
       end

       it "displays comment" do
         page.should have_content("comment")
       end
    end

    context "with invalid data" do
      before do
        click_button "Comentar"
      end

      it "displays error message" do
        page.should have_content("Escreva o seu comentário!")
      end 

      it "redirects to the article page" do
        current_path.should eql(article_path(article))
      end
    end
  end
end