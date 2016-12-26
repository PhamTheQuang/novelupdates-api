class Group < ActiveRecord::Base

  has_many :releases, dependent: :destroy, inverse_of: :group

  validates :title, presence: true
end
