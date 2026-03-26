class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.decimal :subtotal
      t.decimal :tax_amount
      t.decimal :total
      t.string :province_name
      t.decimal :gst_rate
      t.decimal :pst_rate
      t.decimal :hst_rate
      t.string :stripe_payment_id

      t.timestamps
    end
  end
end
