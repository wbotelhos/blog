require 'spec_helper'

describe ArticlesController do
  let(:article_draft) { FactoryGirl.create :article_draft, title: 'title-0' }
  let(:article_1) { FactoryGirl.create :article_published, title: 'title-1' }
  let(:article_2) { FactoryGirl.create :article_published, title: 'title-2' }
  let(:article_3) { FactoryGirl.create :article_published, title: 'title-3' }
  let(:published_articles) { [article_draft, article_1, article_2, article_3] }

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
    before do
      Article.stub(:search).and_return published_articles.append(article_draft)
    end

    it "receives the params" do
      Article.should_receive(:search).with('query', { page: nil, per_page: 10 })
      get :search, query: 'query'
    end

    context "with no query describe" do
      it "returns all published records" do
        get :search
        assigns(:articles).should == published_articles
      end
    end

    context "with query describe" do
      xit "returns one record" do
        get :search, query: 'title-1'
        assigns(:articles).should == [article_1]
      end

      xit "returns no records" do
        get :search, query: 'inexistent'
        assigns(:articles).should be_empty
      end
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
