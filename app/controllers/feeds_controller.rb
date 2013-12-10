class FeedsController < ApplicationController
  before_filter { request.format = :rss }

  def index
    @articles = Article.published.ordered.recents
  end
end
