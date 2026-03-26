class CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:products).order(:name)
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(12)
  end
end