class AdminController < ApplicationController
  before_filter :require_login

  def index
    @drafts   = Article.home_selected.drafts.by_created
  end
end
