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
    @article = Article.find(params[:id], :include => [:comments, :user])
    comment = Comment.new
    @comment_form = CommentFormPresenter.new(@article, comment)
  end

  def edit
    @article = Article.find(params[:id])
    render :layout => "admin"
  end

  def update
    article = Article.find(params[:id])
    article.update_attributes(params[:article])
    redirect_to article_path(article), :notice => t("flash.articles.create.notice")
  end

  def create
    params[:article][:category_ids] ||= []

    @article = user_session.articles.new(params[:article])

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
