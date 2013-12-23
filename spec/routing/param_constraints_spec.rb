require 'spec_helper'

describe ParamConstraints do
  before do
    Blog::Application.reload_routes!
  end

  context 'with a not labs slug' do
    it 'routes /slug to article#show' do
      expect(get: '/bolinha?slug=bolinha').to route_to(controller: 'articles', action: 'show', slug: 'bolinha')
    end
  end

  context 'with a labs slug' do
    let!(:lab) { FactoryGirl.create :lab, slug: 'raty' }

    it "routes /slug to lab#show" do
      expect(get: "/#{lab.slug}?slug=#{lab.slug}").to route_to(controller: 'labs', action: 'show', slug: lab.slug)
    end
  end
end
