class FeedsController < ApplicationController
  before_action { request.format = :rss }

  def index
    @articles = Article.published.by_published.recents
  end
end
