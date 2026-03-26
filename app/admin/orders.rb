ActiveAdmin.register Order do
  permit_params :status

  # No create/destroy from admin — orders come from customers
  actions :all, except: [:new, :destroy]

  filter :status, as: :select, collection: Order::VALID_STATUSES
  filter :user
  filter :created_at

  index do
    id_column
    column :user
    column :status do |o|
      status_tag o.status, class: o.status
    end
    column :subtotal { |o| number_to_currency(o.subtotal) }
    column :tax_amount { |o| number_to_currency(o.tax_amount) }
    column :total { |o| number_to_currency(o.total) }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :user
      row :status
      row :province_name
      row :subtotal { |o| number_to_currency(o.subtotal) }
      row :gst_rate { |o| "#{(o.gst_rate.to_f * 100).round(3)}%" }
      row :pst_rate { |o| "#{(o.pst_rate.to_f * 100).round(3)}%" }
      row :hst_rate { |o| "#{(o.hst_rate.to_f * 100).round(3)}%" }
      row :tax_amount { |o| number_to_currency(o.tax_amount) }
      row :total { |o| number_to_currency(o.total) }
      row :stripe_payment_id
      row :created_at
    end

    panel "Order Items" do
      table_for order.order_items.includes(:product) do
        column "Product" do |item|
          link_to item.product.name, admin_product_path(item.product)
        end
        column :quantity
        column "Unit Price" do |item|
          number_to_currency(item.unit_price)
        end
        column "Subtotal" do |item|
          number_to_currency(item.subtotal)
        end
      end
    end
  end

  form do |f|
    f.inputs "Update Order Status" do
      f.input :status, as: :select, collection: Order::VALID_STATUSES
    end
    f.actions
  end
end