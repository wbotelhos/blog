class CategoriesController < ApplicationController
  before_filter :require_login, except: [:index, :show]

  def create
    @category = Category.new params[:category]

    if @category.save
      redirect_to root_path, notice: t('flash.categories.create.notice')
    else
      render :new, layout: 'admin'
    end
  end

  def edit
    @category = Category.find params[:id]
    render layout: 'admin'
  end

  def index
    redirect_to root_path
  end

  def new
    @category = Category.new
    render layout: 'admin'
  end

  def show
    if params[:slug].present?
      @articles = Article.by_category params[:slug]
    else
      redirect_to root_path
    end
  end

  def update
    @category = Category.find params[:id]

    if @category.update_attributes params[:category]
      redirect_to root_path, notice: t('flash.categories.update.notice')
    else
      render :edit, layout: 'admin'
    end
  end
end
