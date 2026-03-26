class ProductsController < ApplicationController
  def index
    @categories = Category.all.order(:name)
    @products = Product.includes(:category).order(:name)

    # Feature 2.6 — keyword search + category filter
    if params[:query].present?
      q = "%#{params[:query]}%"
      @products = @products.where("name LIKE ? OR description LIKE ?", q, q)
      @search_query = params[:query]
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      @selected_category = Category.find_by(id: params[:category_id])
    end

    # Feature 2.4 — filters
    case params[:filter]
    when "on_sale"        then @products = @products.on_sale
    when "new"            then @products = @products.new_arrivals
    when "recently_updated" then @products = @products.recently_updated
    end

    @active_filter = params[:filter]

    # Feature 2.5 — pagination
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.includes(:category).find(params[:id])
  end
end