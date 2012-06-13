require "spec_helper"

describe ArticlesController do

  describe ":search" do
    xit "should receives the params" do
      controller.should_receive(:search).with(hash_including(:page => "10", :query => "some query"))
      get :search, { :page => 10, :query => "some query" }
    end
  end

end
