Blog::Application.routes.draw do
  root to: 'articles#index'

  controller :admin do
    get   '/admin', action: :index
  end

  controller :articles do
    get   '/articles',                action: :index
    post  '/articles',                action: :create
    get   '/articles/drafts',         action: :drafts
    get   '/articles/new',            action: :new
    get   '/articles/search',         action: :search
    # TODO: articles_path(@article) generates /articles.2
    # So we cannot use it withou as: because cause conflict with form_form @article
    get   '/articles/:id',            action: :preview,   as: :articles_preview
    # TODO: why form_for @article do not apply put method? I need to use url: articles_update.
    # How take off alias and form_for works by it self? articles_path(@article), method: :put
    put   '/articles/:id',            action: :update,    as: :articles_update
    get   '/articles/:id/edit',       action: :edit,      as: :articles_edit
    get   '/:year/:month/:day/:slug', action: :show,      as: :article
  end

  controller :categories do
    get   '/category/:id', action: :show
  end

  controller :comments do
    post  '/articles/:article_id/comments',     action: :create, as: :comments_create
    put   '/articles/:article_id/comments/:id', action: :update, as: :comments_update
  end

  controller :feed do
    get   '/feed', action: :feed
  end

  controller :labs do
    get   '/labs',            action: :index
    post  '/labs',            action: :create
    get   '/labs/drafts',     action: :drafts
    get   '/labs/new',        action: :new
    put   '/labs/:id',        action: :update, as: :labs_update
    get   '/labs/:id/edit',   action: :edit,   as: :labs_edit
  end

  controller :sessions do
    get   '/login',   action: :new
    post  '/login',   action: :create
    get   '/logout',  action: :destroy
  end

  controller :users do
    get   '/about',           action: :about
    get   '/users',           action: :index
    post  '/users',           action: :create
    get   '/users/new',       action: :new
    get   '/users/:id/edit',  action: :edit
  end
end
