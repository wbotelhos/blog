class ArticlesController < ApplicationController
  before_filter :require_login, only: [:new, :create, :edit, :preview, :update, :drafts]

  def index #
    @year_month_articles = Article
                            .select('published_at, slug, title')
                            .published
                            .by_published
                            .group_by { |criteria| criteria.published_at.strftime('%m/%Y') }
  end

  def search
    if params[:query].present?
      @articles = Article.search params[:query], page: params[:page]
      @articles.delete_if { |article| article.published_at.nil? }
    else
      redirect_to root_url
    end
  end

  def new#
    @article = Article.new
  end

  def show #
    @article = Article.where('slug = ?', params[:slug]).first

    if @article.present?
      @comment       = @article.comments.new
      @root_comments = @article.comments.roots
      @title         = @article.title
    else
      redirect_to root_url, alert: t('article.flash.not_found', uri: params[:slug])
    end
  end

  def edit#
    @article = Article.find params[:id]
  end

  def update#
    @article = Article.find params[:id]

    if @article.update_attributes params[:article]
      redirect_to edit_article_url @article
    else
      render :edit
    end
  end

  def publish
    article = Article.find params[:id]
    params[:article][:published_at] = Time.zone.now
    article.update_attributes params[:article]
    redirect_to article_url(article.year, article.month, article.day, article.slug), notice: t('flash.articles.publish.notice')
  end

  def create
    @article = current_user.articles.new params[:article]

    if @article.save
      redirect_to slug_url @article.slug
    else
      render :new
    end
  end
end
