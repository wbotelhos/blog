Rails.application.routes.draw do
  root to: 'articles#index'

  get '/admin', to: 'admin#index'
  get '/feed', to: 'feeds#index'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/profile', to: 'users#edit'
  post '/login', to: 'sessions#create'

  resources :articles, except: %i[destroy show] do
    patch 'publish', on: :member
  end

  resources :labs, except: %i[destroy show] do
    get 'export', on: :member
    get 'gridy', on: :collection
  end

  resources :users, only: :update

  get '/:slug', to: 'labs#show', as: :slug_lab, constraints: ParamConstraints.new
  get '/:slug', to: 'articles#show', as: :slug
end
