Blog::Application.routes.draw do
  root :to => "articles#index"

  controller :admin do
    get "/admin", :action => :index
  end

  controller :feed do
    get "/feed", :action => :feed, :as => :feed
  end

  controller :articles do
    get "/articles",                          :action => :index,  :as => :articles
    post "/articles",                         :action => :create, :as => :create_article
    get "/articles/new",                      :action => :new,    :as => :new_article
    get "/articles/search",                   :action => :search, :as => :search_articles
    get "/articles/:id",                      :action => :show,   :as => :article
    put "/articles/:id",                      :action => :update, :as => :update_article
    get "/articles/:id/edit",                 :action => :edit,   :as => :edit_article
    get "/articles/:year/:month/:day/:slug",  :action => :show,   :as => :slug_article
  end

  controller :categories do
    get "/category/:id", :action => :show, :as => :category
  end

  controller :comments do
    post "/articles/:article_id/comments/new",  :action => :create, :as => :new_comment
    put "/articles/:article_id/comments/:id",   :action => :update, :as => :update_comment
  end

  controller :sessions do
    get "/login",   :action => :new,    :as => :login
    post "/login",  :action => :create, :as => false # TODO: what is the rule to avoid alias?
    get "/logout",  :action => :destroy
  end

  controller :users do
    get "/sobre", :action => :about, :as => :about
  end

end
