class Province < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, length: { is: 2 }
  validates :gst, :pst, :hst, numericality: { greater_than_or_equal_to: 0 }
end