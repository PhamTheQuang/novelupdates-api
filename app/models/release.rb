class Release < ActiveRecord::Base

  belongs_to :series, inverse_of: :releases
  belongs_to :group, inverse_of: :releases

  validates :series, :title, :group, presence: true
end
