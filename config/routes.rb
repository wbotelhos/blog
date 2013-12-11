Blog::Application.routes.draw do
  root to: 'articles#index'

  get  '/admin'  , to: 'admin#index'
  get  '/feed'   , to: 'feeds#index'
  get  '/login'  , to: 'sessions#new'
  get  '/logout' , to: 'sessions#destroy'
  post '/login'  , to: 'sessions#create'

  resources :articles, except: [:destroy, :show] do
    resources :comments, only: [:edit, :create, :update]
  end

  resources :labs, except: [:destroy, :show]

  get '/:slug' , to: 'labs#show'     , as: :slug, constraints: ParamConstraints.new
  get '/:slug' , to: 'articles#show' , as: :slug

  # controller :articles do
  #   get   '/articles/drafts',         action: :drafts
  #   get   '/articles/search',         action: :search
  #   # TODO: articles_path(@article) generates /articles.2
  #   # So we cannot use it withou as: because cause conflict with form_form @article
  #   get   '/articles/:id',            action: :preview,   as: :articles_preview
  #   # TODO: why form_for @article do not apply put method? I need to use url: articles_update.
  #   # How take off alias and form_for works by it self? articles_path(@article), method: :put
  # end

  # controller :categories do
  #   get   '/categories',          action: :index
  #   post  '/categories',          action: :create
  #   get   '/categories/new',      action: :new
  #   put   '/categories/:id',      action: :update, as: :categories_update
  #   get   '/categories/:slug',    action: :show,   as: :categories_show
  #   get   '/categories/:id/edit', action: :edit,   as: :categories_edit
  # end

  # controller :donators do
  #   get   '/donators',          action: :index
  #   post  '/donators',          action: :create
  #   get   '/donators/new',      action: :new
  #   put   '/donators/:id',      action: :update, as: :donators_update
  #   get   '/donators/:id/edit', action: :edit,   as: :donators_edit
  # end

  # controller :links do
  #   get   '/links',           action: :index
  #   post  '/links',           action: :create
  #   get   '/links/new',       action: :new
  #   put   '/links/:id',       action: :update, as: :links_update
  #   get   '/links/:id/edit',  action: :edit,   as: :links_edit
  # end

  # controller :users do
  #   get   '/about',           action: :about
  #   get   '/users',           action: :index
  #   post  '/users',           action: :create
  #   get   '/users/new',       action: :new
  #   put   '/users/:id',       action: :update, as: :users_update
  #   get   '/users/:id/edit',  action: :edit,   as: :users_edit
  # end
end
