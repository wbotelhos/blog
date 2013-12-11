require 'spec_helper'

describe FeedsController do
  let(:criteria) { double.as_null_object }

  describe 'GET #feed' do
    before do
      Article.stub(:published).and_return criteria
      criteria.stub(:recents).and_return criteria
    end

    it 'is filtered by published' do
      Article.should_receive :published
      get :index
    end

    it 'is filtered by recents' do
      criteria.should_receive :recents
      get :index
    end

    it 'is sorted by published date' do
      criteria.should_receive :by_published
      get :index
    end
  end
end
