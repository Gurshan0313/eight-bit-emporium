class Province < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, length: { is: 2 }
  validates :gst, :pst, :hst, numericality: { greater_than_or_equal_to: 0 }

  # Allow Ransack to search these associations (for Active Admin filters)
  def self.ransackable_associations(auth_object = nil)
    ["users"]
  end

  # Allow Ransack to search these attributes (columns)
  def self.ransackable_attributes(auth_object = nil)
    ["name", "abbreviation", "gst", "pst", "hst", "created_at", "updated_at"]
  end
end