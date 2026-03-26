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
    column :price { |p| number_to_currency(p.price) }
    column :on_sale
    column :stock_quantity
    column :image do |p|
      image_tag url_for(p.image), height: 50 if p.image.attached?
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :category
      row :description
      row :condition
      row :price { |p| number_to_currency(p.price) }
      row :on_sale
      row :sale_price { |p| number_to_currency(p.sale_price) if p.sale_price }
      row :stock_quantity
      row :image do |p|
        image_tag url_for(p.image), height: 200 if p.image.attached?
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
      f.input :price
      f.input :on_sale
      f.input :sale_price
      f.input :stock_quantity
      f.input :category
      # Feature 1.3 — Image upload
      f.input :image, as: :file
    end
    f.actions
  end
end