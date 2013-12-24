class ArticlesController < ApplicationController
  before_filter :require_login, except: [:index, :show]

  def create
    @media = current_user.articles.new params[:article]

    if @media.save
      redirect_to edit_article_url @media
    else
      render :new
    end
  end

  def edit
    @media = Article.find params[:id]
  end

  def index
    @year_month_medias = Article.home_selected.published.by_published.group_by { |criteria| criteria.published_at.strftime('%m/%Y') }
  end

  def new
    @media = Article.new
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
    @media = Article.where('slug = ?', params[:slug]).first

    if @media.present?
      @comment       = @media.comments.new
      @root_comments = @media.comments.roots
    else
      redirect_to root_url, alert: t('article.flash.not_found', uri: params[:slug])
    end
  end

  def update
    @media = Article.find params[:id]

    if @media.update_attributes params[:article]
      redirect_to edit_article_url @media
    else
      render :edit
    end
  end
end
