class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty

  def show
    @provinces = Province.order(:name)
    @user = current_user
    @cart_items = build_cart_items
    @subtotal = @cart_items.sum { |i| i[:subtotal] }

    # Use saved province or default to Manitoba
    @province = current_user.province || Province.find_by(abbreviation: "MB")
    @tax_breakdown = calculate_taxes(@subtotal, @province)
    @total = @subtotal + @tax_breakdown[:total_tax]
  end

  def create
    province = Province.find(params[:province_id])
    cart_items = build_cart_items
    subtotal = cart_items.sum { |i| i[:subtotal] }
    tax_breakdown = calculate_taxes(subtotal, province)
    total = subtotal + tax_breakdown[:total_tax]

    # Feature 3.3.2 — Snapshot prices and tax rates at time of purchase
    order = current_user.orders.build(
      status: "pending",
      subtotal: subtotal,
      tax_amount: tax_breakdown[:total_tax],
      total: total,
      province_name: province.name,
      gst_rate: province.gst,
      pst_rate: province.pst,
      hst_rate: province.hst
    )

    # Save address if provided
    if params[:save_address] == "1"
      current_user.update(
        address: params[:address],
        city: params[:city],
        postal_code: params[:postal_code],
        province: province
      )
    end

    order.save!

    cart_items.each do |item|
      order.order_items.create!(
        product: item[:product],
        quantity: item[:quantity],
        unit_price: item[:product].current_price  # locked at purchase time
      )
    end

    # Clear cart
    session[:cart] = {}

    redirect_to order_path(order), notice: "Order placed successfully! Order ##{order.id}"
  end

  private

  def ensure_cart_not_empty
    if session[:cart].blank?
      redirect_to cart_path, alert: "Your cart is empty."
    end
  end

  def build_cart_items
    (session[:cart] || {}).filter_map do |product_id, qty|
      product = Product.find_by(id: product_id)
      next unless product
      { product: product, quantity: qty, subtotal: product.current_price * qty }
    end
  end

  # Feature 3.2.3 — Province-based tax calculation
  def calculate_taxes(subtotal, province)
    gst = (subtotal * province.gst).round(2)
    pst = (subtotal * province.pst).round(2)
    hst = (subtotal * province.hst).round(2)
    { gst: gst, pst: pst, hst: hst, total_tax: gst + pst + hst }
  end
end