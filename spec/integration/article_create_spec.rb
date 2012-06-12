# coding: utf-8
require "spec_helper"

describe Article do

  context "when logged" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:category) { FactoryGirl.create(:category) }

    before do
      login :with => user.email
      click_link "Admin"
      click_link "Criar"
    end

    context "the categories" do
      let!(:category1) { FactoryGirl.create(:category, { :name => "category-1" }) }
      let!(:category2) { FactoryGirl.create(:category, { :name => "category-2" }) }
      let!(:category3) { FactoryGirl.create(:category, { :name => "category-3" }) }

      before do
        visit new_article_path
      end

      it "should display the list" do
        page.should have_content(category1.name)
        page.should have_content(category2.name)
        page.should have_content(category3.name)
      end
    end

    context "save with valid data" do
      before do
        fill_in "article_title", :with => "some title"
        fill_in "article_body", :with => "some text"
        check "category-#{category.id.to_s}"
        click_button "Salvar"
      end

      it "should redirects to edit" do
        current_path.should match(%r[/articles/\d+/edit])
      end

      it "should displays success message" do
        page.should have_content("Rascunho salvo com sucesso!")
      end
    end

    context "save with invalid data" do
      before do
        click_button "Salvar"
      end

      it "should renders form page again" do
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

    it "should redirects to the login page" do
      current_path.should eql(login_path)
    end

    it "should displays error message" do
      page.should have_content("Você precisa estar logado!")
    end
  end

end