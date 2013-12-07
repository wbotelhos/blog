class ArticlesController < ApplicationController
  before_filter :require_login, only: [:new, :create, :edit, :preview, :update, :drafts]
  helper_method :categories, :check_category?

  def drafts
    @articles = Article.drafts
    render layout: 'admin'
  end

  def index #
    @year_month_articles = Article
                            .select('published_at, slug, title')
                            .published
                            .ordered
                            .group_by { |criteria| criteria.published_at.strftime('%m/%Y') }
  end

  def preview
    @article = Article.find params[:id]
  end

  def search
    if params[:query].present?
      @articles = Article.search params[:query], page: params[:page]
      @articles.delete_if { |article| article.published_at.nil? }
    else
      redirect_to root_url
    end
  end

  def new
    @article = Article.new
    render layout: 'admin'
  end

  def show #
    @article = Article.where('slug = ?', params[:slug]).first
    @comment = @article.comments.new

    if @article.present?
      @root_comments = @article.comments.roots
    else
      redirect_to root_url, alert: t('article.flash.not_found', uri: params[:slug])
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
      redirect_to articles_edit_url(@article), notice: t('flash.articles.update.notice')
    else
      render :edit, layout: 'admin'
    end
  end

  def publish
    article = Article.find params[:id]
    params[:article][:published_at] = Time.zone.now
    article.update_attributes params[:article]
    redirect_to article_url(article.year, article.month, article.day, article.slug), notice: t('flash.articles.publish.notice')
  end

  def create
    params[:article][:category_ids] ||= []

    @article = current_user.articles.new params[:article]

    if @article.save
      redirect_to articles_edit_url(@article), notice: t('flash.articles.draft.notice')
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
