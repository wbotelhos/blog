require "spec_helper"

describe ArticlesController do

  describe ":search" do
    it "delegates to ArticleSearch adapter" do
      ArticleSearch.should_receive(:search).with(hash_including(:page => "10", :query => "query"))
      get :search, :page => 10, :query => "query"
    end
  end

end
