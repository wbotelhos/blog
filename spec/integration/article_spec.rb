# coding: utf-8

require "spec_helper"

describe "Article show" do
  let!(:article) { articles(:article) }

  before do
    visit article_path(article)
  end

  it "should redirects to show page" do
    current_path.should match(%r[/articles/\d+])
  end

  it "should remove <!--more--> tag" do
    page.should_not have_content("<!--more-->")
  end

end

describe "Create article" do

  context "when logged" do
    let!(:user) { users(:user) }
    let!(:category) { categories(:category) }

    before do
      login :with => user.email
      click_link "Admin!"
      click_link "Criar"
    end

    context "presents categories" do
      let!(:category1) { FactoryGirl.create(:category, { :name => "category-1" }) }
      let!(:category2) { FactoryGirl.create(:category, { :name => "category-2" }) }
      let!(:category3) { FactoryGirl.create(:category, { :name => "category-3" }) }

      before do
        visit new_article_path
      end

      it "present the categories" do
        page.should have_content(category1.name)
        page.should have_content(category2.name)
        page.should have_content(category3.name)
      end
    end

    context "with valid data" do
      before do
        fill_in "article_title", :with => "some title"
        fill_in "article_body", :with => "some text"
        check "category-#{category.id.to_s}"
        click_button "Salvar"
      end

      it "redirects to edit" do
        current_path.should match(%r[/articles/\d+/edit])
      end

      it "displays success message" do
        page.should have_content("Artigo criado com sucesso!")
      end
    end

    context "with invalid data" do
      before do
        click_button "Salvar"
      end

      it "renders form page" do
        current_path.should eql(new_article_path)
      end

      it "should display error message" do
        page.should have_content("Informe o título do artigo!")
      end
    end
  end

  context "when unlogged" do
    before do
      visit new_article_path
    end

    it "redirects to the login page" do
      current_path.should eql(login_path)
    end

    it "displays error message" do
      page.should have_content("Você precisa estar logado!")
    end
  end

end
