require 'spec_helper'

describe ArticlesController do
  let(:drafts) { FactoryGirl.create_list(:article, 3, published_at: nil) }

  describe "GET #drafts" do
    before do
      Article.stub(:drafts).and_return(drafts)
    end

    xit "assigns the unpublished articles to @articles" do
      assigns(:articles).should == drafts
    end

    it "renders the :draft view"

    xit "renders with :admin template" do
      get 'drafts'
      #response.should render_template :admin
      response.should be_successful
    end
  end

  describe "GET #index" do
    it "populates the elements of paginaty"
    it "renders the :index view"
  end

  describe "GET #preview" do
    it "assigns the article to @article"
  end

  describe "GET #search" do
    xit "receives the params" do
      controller.should_receive(:search).with(query: 'query')
      get :search, query: 'query'
    end

    context "with no query describe" do
      it "returns all records"
    end

    context "with query describe" do
      it "returns all records"
      it "returns one record"
      it "returns no records"
    end
  end

  describe "GET #new" do
    it "assigns a new Article to @article"
    it "renders the :new page"
    it "renders with :admin template"
  end

  describe "GET #show" do
    it "assigns the requested article to @article"
    it "assigns a comment form to @comment_form"
    it "renders the :show page"
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "assigns the requested article to @article"
      it "slug the title"
      it "set the new attributes and update it"
      it "redirects to the :edit page"
      it "renders with :admin template"
      it "shows update message"
    end

    context "with invalid attributes" do
      it "does not update the article"
      it "re-renders the :edit page"
      it "re-renders with :admin template"
      it "shows the error messages"
    end
  end

  describe "PUT #publish" do
    it "assigns the requested article to @article"
    it "slug the title"
    it "fill a published date"
    it "set the new attributes and update it"
    it "redirects to the :show page"
    it "shows published message"
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:category) { FactoryGirl.create(:category) }

      xit "creates a new article" do
        expect {
          post :create, article: { title: article.title, body: article.body, category_ids: [category.id] }
        }.to change(Article, :count).by(1)
      end

      it "assigns the new attributes to an user's article to @article"
      it "slug the title"
      it "saves the article"
      it "redirects to the :edit page"
      it "renders with :admin template"
      it "shows the success messages"
    end

    context "with invalid attributes" do
      it "assigns the new attributes to an user's article to @article"
      it "slug the title"
      it "does not saves the article"
      it "redirects to the :new page"
      it "renders with :admin template"
      it "shows the error messages"
    end
  end
end
