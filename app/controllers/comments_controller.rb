class CommentsController < ApplicationController
  before_filter :require_login, except: :create

  def create
    @article        = Article.find params[:article_id]
    @comment        = @article.comments.new params[:comment]
    @comment.author = is_logged?

    if @comment.save
      redirect_to slug_url @article.slug, anchor: "comment-#{@comment.id}"
    else
      render template: 'articles/show'
    end
  end

  def edit
    @comment    = Comment.find params[:id]
    @article    = Article.new
    @article.id = params[:article_id]
  end

  def update
    @article = Article.find params[:article_id]
    @comment = @article.comments.find params[:id]

    if @comment.update_attributes params[:comment]
      redirect_to slug_url @article.slug, anchor: "comment-#{@comment.id}"
    else
      render :edit
    end
  end
end
