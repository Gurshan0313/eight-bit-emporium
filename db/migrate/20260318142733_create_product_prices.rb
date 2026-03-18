class CreateProductPrices < ActiveRecord::Migration[7.2]
  def change
    create_table :product_prices do |t|
      t.decimal :price
      t.datetime :effective_date
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
