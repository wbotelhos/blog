require "spec_helper"

describe ArticleSearch do

  it "delegates to questoin.search" do
    Article.should_receive(:search).with("query", { :page => 2, :per_page => Paginaty::LIMIT })

    ArticleSearch.search(:query => "query", :page => 2)
  end

end
