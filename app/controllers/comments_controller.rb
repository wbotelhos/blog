class CommentsController < ApplicationController
  before_filter :require_login, except: :create
  before_filter :build_resource

  def create
    @media   = @model.find @id
    @comment = @media.comments.new parameters

    assign_author if is_logged?

    if @comment.save
      redirect_to slug_url @media.slug, anchor: "comment-#{@comment.id}"
    else
      render template: "#{@resource}/show"
    end
  end

  def edit
    @comment  = Comment.find params[:id]
    @media    = @model.new
    @media.id = @id
  end

  def update
    @media   = @model.find @id
    @comment = @media.comments.find params[:id]

    if @comment.update_attributes parameters
      redirect_to slug_url @media.slug, anchor: "comment-#{@comment.id}"
    else
      render :edit
    end
  end

  private

  def assign_author
    @comment.author  = true
    @comment.email   = @current_user.email
    @comment.name    = CONFIG['author']
    @comment.pending = false
    @comment.url     = CONFIG['url_http']
  end

  def build_resource
    @resource, @id = request.path.split('/')[1, 2]
    @model         = @resource.camelize.singularize.constantize
  end

  def parameters
    params.require(:comment).permit :body, :email, :name, :parent_id, :pending, :url
  end
end
