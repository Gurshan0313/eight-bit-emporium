class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2 }
  validates :address, length: { minimum: 5 }, allow_blank: true
  validates :postal_code,
    format: { with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
              message: "must be a valid Canadian postal code" },
    allow_blank: true
end