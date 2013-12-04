class FeedsController < ApplicationController
  before_filter { request.format = :rss }

  def feed
    @articles = Article.published.recents
  end
end
