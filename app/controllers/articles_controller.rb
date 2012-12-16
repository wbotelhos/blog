class ArticlesController < ApplicationController
  before_filter :require_login, only: [:new, :create, :edit, :preview, :update, :drafts]
  helper_method :categories, :check_category?

  rescue_from Riddle::ConnectionError do
    redirect_to root_path, alert: t('flash.articles.search.alert' )
  end

  def drafts
    @articles = Article.drafts
    render layout: 'admin'
  end

  def index
    @paginaty = Paginaty.filter request: request, entity: Article, params: params
  end

  def preview
    @article = Article.find params[:id]
  end

  def search
    @articles = Article.search params[:query], page: params[:page], per_page: Paginaty::LIMIT
    @articles.delete_if { |article| article.published_at.nil? }
  end

  def new
    @article = Article.new
    render layout: 'admin'
  end

  def show
    # TODO: apply query to check only Date and ignore Time.
    published_at = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    @article = Article.where('slug = ?', params[:slug]).first

    comment = Comment.new # TODO: should I assign with @ just for test here?
    @comment_form = CommentFormPresenter.new(@article, comment)
  end

  def edit
    @article = Article.find params[:id]
    render layout: 'admin'
  end

  def update
    article = Article.find params[:id]
    article.update_attributes params[:article]
    redirect_to articles_edit_path(article), notice: t('flash.articles.update.notice')
  end

  def publish
    article = Article.find params[:id]
    params[:article][:published_at] = Time.now
    article.update_attributes params[:article]
    redirect_to article_path(article.year, article.month, article.day, article.slug), notice: t('flash.articles.publish.notice')
  end

  def create
    params[:article][:category_ids] ||= []

    @article = user_session.articles.new params[:article]

    if @article.save
      redirect_to articles_edit_path(@article), notice: t('flash.articles.create.notice')
    else
      render :new, layout: 'admin'
    end
  end

  private

  def categories
    @categories ||= Category.scoped
  end

  def check_category?(article, category)
    if !article.nil? && !article.categories.nil? && article.categories.include?(category)
      'checked="checked"'
    end
  end
end
