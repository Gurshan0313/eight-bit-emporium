ActiveAdmin.register Product do
  permit_params :name, :description, :condition, :price, :stock_quantity,
                :category_id, :on_sale, :sale_price, :image

  # Feature 2.4 — Filters in admin
  filter :name
  filter :category
  filter :condition, as: :select, collection: Product::VALID_CONDITIONS
  filter :on_sale
  filter :price

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :condition
    column :price do |product|
      number_to_currency(product.price)
    end
    column :on_sale
    column :stock_quantity
    column :image do |product|
      image_tag url_for(product.image), height: 50 if product.image.attached?
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :category
      row :description
      row :condition
      row :price do |product|
        number_to_currency(product.price)
      end
      row :on_sale
      row :sale_price do |product|
        number_to_currency(product.sale_price) if product.sale_price
      end
      row :stock_quantity
      row :image do |product|
        image_tag url_for(product.image), height: 200 if product.image.attached?
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :condition, as: :select, collection: Product::VALID_CONDITIONS
      f.input :price, as: :number, input_html: { min: 0.01, step: 0.01 }   # ← add this
      f.input :on_sale
      f.input :sale_price, as: :number, input_html: { min: 0.01, step: 0.01 }  # also fix sale_price
      f.input :stock_quantity, input_html: { min: 0 }
      f.input :category
      f.input :image, as: :file
    end
    f.actions
  end
end