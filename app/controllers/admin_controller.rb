class AdminController < ApplicationController
  before_filter :require_login

  def index
    @drafts = Article.select('published_at, slug, title').drafts
  end
end
