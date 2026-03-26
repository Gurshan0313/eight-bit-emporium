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
    column :status do |order|
      status_tag order.status, class: order.status
    end
    column :subtotal do |order|
      number_to_currency(order.subtotal)
    end
    column :tax_amount do |order|
      number_to_currency(order.tax_amount)
    end
    column :total do |order|
      number_to_currency(order.total)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :user
      row :status
      row :province_name
      row :subtotal do |order|
        number_to_currency(order.subtotal)
      end
      row :gst_rate do |order|
        "#{(order.gst_rate.to_f * 100).round(3)}%"
      end
      row :pst_rate do |order|
        "#{(order.pst_rate.to_f * 100).round(3)}%"
      end
      row :hst_rate do |order|
        "#{(order.hst_rate.to_f * 100).round(3)}%"
      end
      row :tax_amount do |order|
        number_to_currency(order.tax_amount)
      end
      row :total do |order|
        number_to_currency(order.total)
      end
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