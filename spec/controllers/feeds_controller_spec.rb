# frozen_string_literal: true

RSpec.describe FeedsController do
  let(:criteria) { double.as_null_object }

  describe 'GET #feed' do
    before do
      allow(Article).to receive(:published).and_return criteria
      allow(criteria).to receive(:recents).and_return criteria
    end

    it 'is filtered by published' do
      expect(Article).to receive :published
      get :index
    end

    it 'is filtered by recents' do
      expect(criteria).to receive :recents
      get :index
    end

    it 'is sorted by published date' do
      expect(criteria).to receive :by_published
      get :index
    end
  end
end
