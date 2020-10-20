class AdminController < ApplicationController
  before_action :require_login

  def index
    @drafts = Article.home_selected.drafts.by_created
  end
end
