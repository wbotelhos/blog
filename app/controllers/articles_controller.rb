class ArticlesController < ApplicationController
  before_filter :require_login, except: [:index, :show]

  def create
    @article = current_user.articles.new params[:article]

    if @article.save
      redirect_to slug_url @article.slug
    else
      render :new
    end
  end

  def edit
    @article = Article.find params[:id]
  end

  def index
    # TODO: extract it as a scope and test.
    @year_month_articles = Article.select('published_at, slug, title').published.by_published.group_by { |criteria| criteria.published_at.strftime('%m/%Y') }
  end

  def new
    @article = Article.new
  end

  def publish # pending
    article                         = Article.find params[:id]
    params[:article][:published_at] = Time.now

    if article.update_attributes params[:article]
      redirect_to slug_url article.slug
    else
      render :edit
    end
  end

  def show
    @article = Article.where('slug = ?', params[:slug]).first

    if @article.present?
      @comment       = @article.comments.new
      @root_comments = @article.comments.roots
      @title         = @article.title
    else
      redirect_to root_url, alert: t('article.flash.not_found', uri: params[:slug])
    end
  end

  def update
    @article = Article.find params[:id]

    if @article.update_attributes params[:article]
      redirect_to edit_article_url @article
    else
      render :edit
    end
  end
end
