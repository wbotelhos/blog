class AdminController < ApplicationController
  before_filter :require_login

  def index
    @drafts   = Article.home_selected.drafts.by_created
    @pendings = Comment.pendings.includes(:commentable) # how to use .select('commentable.slug, commentable_type, email, id') with includes?
  end
end
