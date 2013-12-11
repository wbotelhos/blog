class FeedsController < ApplicationController
  before_filter { request.format = :rss }

  def index
    @articles = Article.published.by_published.recents
  end
end
