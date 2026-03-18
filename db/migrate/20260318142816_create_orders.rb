class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.datetime :order_date
      t.decimal :total
      t.string :status
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
