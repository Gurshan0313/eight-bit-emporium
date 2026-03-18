class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  VALID_STATUSES = %w[Pending Shipped Delivered Cancelled].freeze

  validates :order_date, presence: true
  validates :total, presence: true,
    numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: VALID_STATUSES }
end