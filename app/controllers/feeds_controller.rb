class FeedsController < ApplicationController
  before_filter { request.format = :rss }

  def index
    @articles = Article.published.recents
  end
end
