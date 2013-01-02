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
  end

  def preview
    @article = Article.find params[:id]
  end

  def search
    if params[:query].present?
      @articles = Article.search params[:query], page: params[:page]
      @articles.delete_if { |article| article.published_at.nil? }
    else
      redirect_to root_path
    end
  end

  def new
    @article = Article.new
    render layout: 'admin'
  end

  def show
    # TODO: apply query to check only Date and ignore Time.
    # published_at = Time.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    @article = Article.where('slug = ?', params[:slug]).first

    if @article.present?
      comment = Comment.new # TODO: should I assign with @ just for test here?
      @comment_form = CommentFormPresenter.new(@article, comment)
    else
      uri = "/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:slug]}"
      redirect_to root_path, alert: t('flash.articles.not_found_html', uri: uri).html_safe
    end
  end

  def edit
    @article = Article.find params[:id]
    render layout: 'admin'
  end

  def update
    article = params[:article]

    article[:category_ids] = [] if article[:category_ids].nil?

    @article = Article.find params[:id]

    if @article.update_attributes article
      redirect_to articles_edit_path(@article), notice: t('flash.articles.update.notice')
    else
      render :edit, layout: 'admin'
    end
  end

  def publish
    article = Article.find params[:id]
    params[:article][:published_at] = Time.zone.now
    article.update_attributes params[:article]
    redirect_to article_path(article.year, article.month, article.day, article.slug), notice: t('flash.articles.publish.notice')
  end

  def create
    params[:article][:category_ids] ||= []

    @article = user_session.articles.new params[:article]

    if @article.save
      redirect_to articles_edit_path(@article), notice: t('flash.articles.draft.notice')
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
