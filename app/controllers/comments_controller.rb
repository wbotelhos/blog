class CommentsController < ApplicationController
  before_filter :require_login, except: :create

  def create
    @media   = Article.find params[:article_id]
    @comment = @media.comments.new params[:comment]

    assign_author if is_logged?

    if @comment.save
      redirect_to slug_url @media.slug, anchor: "comment-#{@comment.id}"
    else
      render template: 'articles/show'
    end
  end

  def edit
    @comment  = Comment.find params[:id]
    @media    = Article.new
    @media.id = params[:article_id]
  end

  def update
    @media = Article.find params[:article_id]
    @comment = @media.comments.find params[:id]

    if @comment.update_attributes params[:comment]
      redirect_to slug_url @media.slug, anchor: "comment-#{@comment.id}"
    else
      render :edit
    end
  end

  private

  def assign_author
    @comment.author = true
    @comment.email = @current_user.email
    @comment.name  = @current_user.name
    @comment.url   = CONFIG['url']
  end
end
