class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  VALID_STATUSES = %w[pending paid shipped cancelled].freeze

  validates :status, presence: true, inclusion: { in: VALID_STATUSES }
  validates :subtotal, :tax_amount, :total,
    numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def paid?
    status == "paid"
  end
end