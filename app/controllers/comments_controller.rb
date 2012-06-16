class CommentsController < ApplicationController

  before_filter :require_login, :only => [:update]

  def create
    @article = Article.find(params[:article_id])

    params[:comment][:name] = nil if params[:comment][:name] == I18n.t("activerecord.attributes.comment.name")
    params[:comment][:email] = nil if params[:comment][:email] == I18n.t("activerecord.attributes.comment.email")
    params[:comment][:url] = nil if params[:comment][:url] == I18n.t("activerecord.attributes.comment.url")
    params[:comment][:body] = nil if params[:comment][:body] == %[\n#{I18n.t("activerecord.attributes.comment.body")}] # TODO: why :comment:body preppend one \n?

    @comment = @article.comments.new(params[:comment])
    @comment.author = is_logged?
    @comment.comment = Comment.find(params[:comment_id]) unless params[:comment_id].nil?

    if @comment.save
      CommentMailer.new(@article, @comment).send

      flash[:notice] = t("flash.comments.create.notice")
    else
      flash[:alert] = t("flash.comments.create.alert")
    end

    redirect_to article_path(@article)
  end

  def update
    comment = Comment.find(params[:id])

    if comment.update_attributes(params[:comment])
      flash[:notice] = t("flash.comments.update.notice")
    else
      flash[:alert] = t("flash.comments.update.alert")
    end

    redirect_to article_path(params[:article_id])
  end

end
 