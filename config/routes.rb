Blog::Application.routes.draw do
  root to: 'articles#index'

  get  '/admin'   , to: 'admin#index'
  get  '/feed'    , to: 'feeds#index'
  get  '/login'   , to: 'sessions#new'
  get  '/logout'  , to: 'sessions#destroy'
  get  '/profile' , to: 'users#edit'
  post '/login'   , to: 'sessions#create'

  resources :articles, except: [:destroy, :show] do
    resources :comments, only: [:edit, :create, :update]
  end

  resources :labs, except: [:destroy, :show] do
    get 'gridy'  , on: :collection

    get 'export' , on: :member

    resources :comments, only: [:edit, :create, :update]
  end

  resources :users, only: :update

  get '/:slug' , to: 'labs#show'     , as: :slug, constraints: ParamConstraints.new
  get '/:slug' , to: 'articles#show' , as: :slug
end
