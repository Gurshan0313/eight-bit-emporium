class Product < ApplicationRecord
  belongs_to :category
  has_many :product_prices, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items   # many-to-many through order_items
end