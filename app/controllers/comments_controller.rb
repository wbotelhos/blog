class CommentsController < ApplicationController
  permits :body, :email, :name, :parent_id, :pending, :url

  before_filter :require_login, except: :create
  before_filter :build_resource

  def create(comment)
    @media   = @model.find @id
    @comment = @media.comments.new comment

    assign_author if is_logged?

    if @comment.save
      redirect_to slug_url @media.slug, anchor: "comment-#{@comment.id}"
    else
      render template: "#{@resource}/show"
    end
  end

  def edit(id)
    @comment  = Comment.find id
    @media    = @model.new
    @media.id = @id
  end

  def update(id, comment)
    @media   = @model.find @id
    @comment = @media.comments.find id

    if @comment.update_attributes comment
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
end
