class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  VALID_STATUSES = %w[pending paid shipped cancelled].freeze

  validates :status, presence: true, inclusion: { in: VALID_STATUSES }
  validates :subtotal, :tax_amount, :total,
    numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "products", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst_rate", "hst_rate", "id", "province_name", "pst_rate", "status", "stripe_payment_id", "subtotal", "tax_amount", "total", "updated_at", "user_id"]
  end
end