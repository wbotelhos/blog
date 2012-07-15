class ArticlesController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :edit, :update]
  helper_method :categories, :check_category?, :markdown

  rescue_from Riddle::ConnectionError do
    redirect_to root_path, :alert => t("flash.articles.search.alert" )
  end

  def index
    @paginaty = Paginaty.filter({ :request => request, :entity => Article, :params => params, :order => "desc" })
  end

  def search
    @articles = Article.search(params[:query], { :page => params[:page], :per_page => Paginaty::LIMIT })
  end

  def new
    @article = Article.new
    render :layout => "admin"
  end

  def show
    # TODO: apply query to check only Date and ignore Time.
    published_at = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    @article = Article.where("slug = ?", params[:slug]).first

    comment = Comment.new
    @comment_form = CommentFormPresenter.new(@article, comment)
  end

  def edit
    @article = Article.find(params[:id])
    render :layout => "admin"
  end

  def update
    article = Article.find(params[:id])

    params[:article][:slug] = article.slug_it(params[:article][:title])

    article.update_attributes(params[:article])

    redirect_to edit_article_path(article), :notice => t("flash.articles.update.notice")
    #redirect_to slug_article_path(article.year, article.month, article.day, article.slug), :notice => t("flash.articles.create.notice")
  end

  def publish
    article = Article.find(params[:id])

    params[:article][:slug] = article.slug_it(params[:article][:title])
    params[:article][:published_at] = Time.now

    article.update_attributes(params[:article])

    redirect_to slug_article_path(article.year, article.month, article.day, article.slug), :notice => t("flash.articles.publish.notice")
  end

  def create
    params[:article][:category_ids] ||= []

    @article = user_session.articles.new(params[:article])

    @article.slug = @article.slug_it(@article.title)

    if @article.save
      redirect_to edit_article_path(@article), :notice => t("flash.articles.create.notice")
    else
      render :new, :layout => "admin"
    end
  end

  private

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, :lexer => language, :options => { :encoding => "utf-8" })
    end
  end

  def markdown(content)
    renderer = HTMLwithPygments.new(:hard_wrap => true) # :filter_html => true

    options = {
      :autolink           => true,
      :no_intra_emphasis  => true,
      :fenced_code_blocks => true,
      :lax_html_blocks    => true,
      :strikethrough      => true,
      :superscript        => true
    }

    Redcarpet::Markdown.new(renderer, options).render(content).html_safe
  end

  def categories
    @categories ||= Category.scoped
  end

  def check_category?(article, category)
    if !article.nil? && !article.categories.nil? && article.categories.include?(category)
      %[checked="checked"]
    end
  end

end
