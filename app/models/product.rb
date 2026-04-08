class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_one_attached :image   # Active Storage

  VALID_CONDITIONS = %w[Mint Excellent Good Acceptable].freeze

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :condition, presence: true, inclusion: { in: VALID_CONDITIONS }
  validates :sale_price, numericality: { greater_than: 0 }, allow_nil: true

  scope :on_sale, -> { where(on_sale: true) }
  scope :new_arrivals, -> { where("created_at >= ?", 3.days.ago) }
  scope :recently_updated, -> { where("updated_at >= ? AND created_at < ?", 3.days.ago, 3.days.ago) }

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "condition", "created_at", "description", "id", "name", "on_sale", "price", "sale_price", "stock_quantity", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "order_items", "orders"]
  end

  def current_price
    on_sale? && sale_price.present? ? sale_price : price
  end
end





