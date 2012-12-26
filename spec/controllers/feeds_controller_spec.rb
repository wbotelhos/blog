require 'spec_helper'

describe FeedController do
  let(:article_draft) { FactoryGirl.create :article_draft }
  let(:article_published) { FactoryGirl.create :article_published }
  let(:criteria) { mock_model(Article).as_null_object }

  describe 'GET #feed' do
    before do
      Article.stub(:published).and_return criteria
      criteria.stub(:recents).and_return criteria
    end

    it 'filter by published' do
      Article.should_receive :published
      get :feed
    end

    it 'filter by recents' do
      criteria.should_receive :recents
      get :feed
    end
  end
end
