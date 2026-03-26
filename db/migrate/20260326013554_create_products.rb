class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :condition
      t.integer :stock_quantity
      t.decimal :price
      t.boolean :on_sale
      t.decimal :sale_price
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
