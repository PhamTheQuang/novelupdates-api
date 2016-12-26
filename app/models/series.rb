class Series < ActiveRecord::Base

  has_many :releases, dependent: :destroy, inverse_of: :series

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true
end
