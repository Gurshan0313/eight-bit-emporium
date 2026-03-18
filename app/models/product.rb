class Product < ApplicationRecord
  belongs_to :category
  has_many :product_prices, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  VALID_CONDITIONS = %w[Mint Excellent Good Acceptable].freeze

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :condition, presence: true, inclusion: { in: VALID_CONDITIONS,
    message: "%{value} is not a valid condition. Use: Mint, Excellent, Good, or Acceptable" }
  validates :stock_quantity, presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end