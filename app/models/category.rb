class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10 }
end