require 'spec_helper'

describe ParamConstraints do
  before do
    Blog::Application.reload_routes!
  end

  it 'routes /bolinha to article#show' do
    expect(get: '/bolinha?slug=bolinha').to route_to(controller: 'articles', action: 'show', slug: 'bolinha')
  end

  it 'routes /raty to lab#show' do
    expect(get: '/raty?slug=raty').to route_to(controller: 'labs', action: 'show', slug: 'raty')
  end

  it 'routes /capty to lab#show' do
    expect(get: '/capty?slug=capty').to route_to(controller: 'labs', action: 'show', slug: 'capty')
  end

  it 'routes /stepy to lab#show' do
    expect(get: '/stepy?slug=stepy').to route_to(controller: 'labs', action: 'show', slug: 'stepy')
  end

  it 'routes /chrony to lab#show' do
    expect(get: '/chrony?slug=chrony').to route_to(controller: 'labs', action: 'show', slug: 'chrony')
  end

  it 'routes /flury to lab#show' do
    expect(get: '/flury?slug=flury').to route_to(controller: 'labs', action: 'show', slug: 'flury')
  end

  it 'routes /mory to lab#show' do
    expect(get: '/mory?slug=mory').to route_to(controller: 'labs', action: 'show', slug: 'mory')
  end

  it 'routes /taby to lab#show' do
    expect(get: '/taby?slug=taby').to route_to(controller: 'labs', action: 'show', slug: 'taby')
  end

  it 'routes /validaty to lab#show' do
    expect(get: '/validaty?slug=validaty').to route_to(controller: 'labs', action: 'show', slug: 'validaty')
  end

  it 'routes /populaty to lab#show' do
    expect(get: '/populaty?slug=populaty').to route_to(controller: 'labs', action: 'show', slug: 'populaty')
  end

  it 'routes /flapy to lab#show' do
    expect(get: '/flapy?slug=flapy').to route_to(controller: 'labs', action: 'show', slug: 'flapy')
  end

  it 'routes /gridy to lab#show' do
    expect(get: '/gridy?slug=gridy').to route_to(controller: 'labs', action: 'show', slug: 'gridy')
  end

  it 'routes /styly to lab#show' do
    expect(get: '/styly?slug=styly').to route_to(controller: 'labs', action: 'show', slug: 'styly')
  end

  it 'routes /treefy to lab#show' do
    expect(get: '/treefy?slug=treefy').to route_to(controller: 'labs', action: 'show', slug: 'treefy')
  end
end
