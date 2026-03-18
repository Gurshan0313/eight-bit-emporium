class Customer < ApplicationRecord
  has_secure_password
  has_many :orders, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 80 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :address, presence: true, length: { minimum: 10 }
end