class CartsController < ApplicationController
  def show
    @cart_items = cart_items
  end

  # Feature 3.1.1 — Add to cart
  def add_item
    product_id = params[:product_id].to_s
    session[:cart] ||= {}
    session[:cart][product_id] = (session[:cart][product_id] || 0) + 1
    redirect_back fallback_location: root_path, notice: "Added to cart!"
  end

  # Feature 3.1.2 — Update quantity
  def update_item
    product_id = params[:product_id].to_s
    qty = params[:quantity].to_i

    if qty <= 0
      session[:cart]&.delete(product_id)
    else
      session[:cart][product_id] = qty
    end

    redirect_to cart_path, notice: "Cart updated."
  end

  # Feature 3.1.2 — Remove item
  def remove_item
    product_id = params[:product_id].to_s
    session[:cart]&.delete(product_id)
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def cart_items
    return [] unless session[:cart].present?
    product_ids = session[:cart].keys
    products = Product.where(id: product_ids).index_by { |p| p.id.to_s }
    session[:cart].filter_map do |product_id, qty|
      product = products[product_id]
      next unless product
      { product: product, quantity: qty, subtotal: product.current_price * qty }
    end
  end
end