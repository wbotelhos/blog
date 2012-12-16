class FeedController < ApplicationController
  before_filter do
    request.format = :rss
  end

  def feed
    @articles = Article.published.recents
  end
end
