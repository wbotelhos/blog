class ArticlesController < ApplicationController
  before_action :require_login, except: %i[index show]

  layout 'admin', except: %i[index show]

  def create
    @media = current_user.articles.new parameters

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

  def publish
    article = Article.find params[:id]

    if article.publish!
      redirect_to root_url, notice: t('article.flash.published')
    else
      render :edit
    end
  end

  def show
    @media = Article.where('slug = ?', params[:slug]).first

    if @media.present?
      @title = @media.title

      @article = ArticlePresenter.new(@media)
    else
      redirect_to root_url, alert: t('article.flash.not_found', uri: params[:slug])
    end
  end

  def update
    @media = Article.find params[:id]

    if @media.update_attributes parameters
      redirect_to edit_article_url @media
    else
      render :edit
    end
  end

  private

  def parameters
    params.require(:article).permit :body, :published_at, :title
  end
end
