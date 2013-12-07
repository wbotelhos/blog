# coding: utf-8

class CommentsController < ApplicationController
  before_filter :require_login, only: :update

  def create
    @article        = Article.find params[:article_id]
    @comment        = @article.comments.new params[:comment]
    @comment.author = is_logged?

    if @comment.save
      redirect_to slug_url(@article.slug, anchor: "comment-#{@comment.id}")
    else
      render template: 'articles/show'
    end
  end

  def update
    @article = Article.find params[:article_id]

    @comment = @article.comments.find params[:id]

    if @comment.update_attributes params[:comment]
      flash[:notice] = t('flash.comments.update.notice')
      redirect_to slug_url(@article.slug, anchor: :new_comment)
    else
      render template: 'articles/show'
    end
  end
end
