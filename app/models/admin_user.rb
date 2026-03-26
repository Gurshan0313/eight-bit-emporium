class AdminUser < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at"]

  end

  # If AdminUser has associations
  def self.ransackable_associations(auth_object = nil)
    []
  end
end