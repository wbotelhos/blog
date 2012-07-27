# coding: utf-8
require "spec_helper"

describe Comment, "#create" do
  let!(:user) { FactoryGirl.create(:user, { :id => 1 }) }
  let!(:article) { FactoryGirl.create(:article_published, { :id => 1 }) }

  context "when logged" do
    before do
      login :with => user.email
      visit article_path(article.year, article.month, article.day, article.slug)
    end

    context "with valid data" do
      before do
        fill_in "comment_body", :with => "comment"
        click_button "Comentar"
      end

      it "redirects to the article page" do
        current_path.should eql(article_path(article.year, article.month, article.day, article.slug))
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

      it "redirects to the article page" do
        current_path.should eql(article_path(article.year, article.month, article.day, article.slug))
      end

      it "displays error message" do
        page.should have_content("Escreva o seu comentário!")
      end 
    end

    context "with shadow data" do
      before do
        click_button "Comentar"
      end

      it "redirects to the article page" do
        current_path.should eql(article_path(article.year, article.month, article.day, article.slug))
      end

      xit "displays error message" do
        page.should have_content("Comentário deve ser preenchido!")
      end 
    end
  end

  context "when unlogged" do
    before do
      visit article_path(article.year, article.month, article.day, article.slug)
    end

    context "with valid data" do
      before do
        fill_in "comment_name",   :with => "some name"
        fill_in "comment_email",  :with => "some_email@email.com"
        fill_in "comment_url",    :with => "http://some_url.com"
        fill_in "comment_body",   :with => "some comment"
        click_button "Comentar"
      end

      it "redirects to the article page" do
        current_path.should eql(article_path(article.year, article.month, article.day, article.slug))
      end

       it "displays success message" do
         page.should have_content("Seu comentário foi adicionado!")
       end

       it "displays comment" do
         page.should have_content("some name")
         page.should have_content("some comment")
       end
    end

    context "with invalid data" do
      before do
        click_button "Comentar"
      end

      it "redirects to the article page" do
        current_path.should eql(article_path(article.year, article.month, article.day, article.slug))
      end

      xit "displays error message" do
        page.should have_content("Nome deve ser preenchido!")
        page.should have_content("E-mail deve ser preenchido!")
        page.should have_content("Comentário deve ser preenchido!")
      end 
    end

    context "with shadow data" do
      before do
        click_button "Comentar"
      end

      it "redirects to the article page" do
        current_path.should eql(article_path(article.year, article.month, article.day, article.slug))
      end

      xit "displays error message" do
        page.should have_content("Nome deve ser preenchido!")
        page.should have_content("E-mail deve ser preenchido!")
        page.should have_content("Comentário deve ser preenchido!")
      end 
    end
  end
end
