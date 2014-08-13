class ArticlesController < ApplicationController
  permits :body, :published_at, :slug, :title

  before_filter :require_login, except: [:index, :show]

  def create(article)
    @media = current_user.articles.new article

    if @media.save
      redirect_to edit_article_url @media
    else
      render :new
    end
  end

  def edit(id)
    @media = Article.find id
  end

  def index
    @year_month_medias = Article.home_selected.published.by_published.group_by { |criteria| criteria.published_at.strftime('%m/%Y') }
  end

  def new
    @media = Article.new
  end

  def publish(id)
    article = Article.find id

    if article.publish!
      redirect_to root_url, notice: t('article.flash.published')
    else
      render :edit
    end
  end

  def show(slug)
    @media = Article.where('slug = ?', slug).first

    if @media.present?
      @comment       = @media.comments.new
      @root_comments = @media.comments.roots
      @title         = @media.title
    else
      redirect_to root_url, alert: t('article.flash.not_found', uri: slug)
    end
  end

  def update(id, article)
    @media = Article.find id

    if @media.update_attributes article
      redirect_to edit_article_url @media
    else
      render :edit
    end
  end
end
