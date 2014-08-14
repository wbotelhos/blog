require 'rails_helper'

describe :routes do
  before do
    Rails.application.reload_routes!
  end

  it 'routes /admin to admin#index' do
    expect(get: '/admin').to route_to(controller: 'admin', action: 'index')
  end

  it 'routes /feed to feeds#index' do
    expect(get: '/feed').to route_to(controller: 'feeds', action: 'index')
  end

  it 'routes /login to sessions#new' do
    expect(get: '/login').to route_to(controller: 'sessions', action: 'new')
  end

  it 'routes /logout to sessions#destroy' do
    expect(get: '/logout').to route_to(controller: 'sessions', action: 'destroy')
  end

  it 'routes /login to sessions#create' do
    expect(post: '/login').to route_to(controller: 'sessions', action: 'create')
  end

  it 'routes /articles/:article_id/comments to comments#create' do
    expect(post: '/articles/1/comments').to route_to(action: 'create', controller: 'comments', article_id: '1')
  end

  it 'routes /articles/:article_id/comments/:id/edit to comments#edit' do
    expect(get: '/articles/1/comments/2/edit').to route_to(action: 'edit', controller: 'comments', article_id: '1', id: '2')
  end

  it 'routes /articles/:article_id/comments/:id to comments#update' do
    expect(put: '/articles/1/comments/2').to route_to(action: 'update', controller: 'comments', article_id: '1', id: '2')
  end

  it 'routes /articles to articles#index' do
    expect(get: '/articles').to route_to(controller: 'articles', action: 'index')
  end

  it 'routes /articles to articles#create' do
    expect(post: '/articles').to route_to(controller: 'articles', action: 'create')
  end

  it 'routes /articles/new to articles#new' do
    expect(get: '/articles/new').to route_to(controller: 'articles', action: 'new')
  end

  it 'routes /articles/:id/edit to articles#edit' do
    expect(get: '/articles/1/edit').to route_to(controller: 'articles', action: 'edit', id: '1')
  end

  it 'routes /articles/:id to articles#update' do
    expect(put: '/articles/1').to route_to(controller: 'articles', action: 'update', id: '1')
  end

  it 'routes /labs to labs#index' do
    expect(get: '/labs').to route_to(controller: 'labs', action: 'index')
  end

  it 'routes /labs to labs#create' do
    expect(post: '/labs').to route_to(action: 'create', controller: 'labs')
  end

  it 'routes /labs/new to labs#new' do
    expect(get: '/labs/new').to route_to(action: 'new', controller: 'labs')
  end

  it 'routes /labs/:id/edit to labs#edit' do
    expect(get: '/labs/1/edit').to route_to(controller: 'labs', action: 'edit', id: '1')
  end

  it 'routes /labs/:id to labs#update' do
    expect(put: '/labs/1').to route_to(controller: 'labs', action: 'update', id: '1')
  end

  it 'routes /:slug to articles#show' do
    expect(get: '/slug').to route_to(controller: 'articles', action: 'show', slug: 'slug')
  end
end
