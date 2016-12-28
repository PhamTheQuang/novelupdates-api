class Group < ActiveRecord::Base

  has_many :releases, dependent: :destroy, inverse_of: :group

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true

  def self.slug_from_url(url)
    if matched = url.match(/#{ENV['short_url']}\/group\/([^\/]+)/)
      matched[1]
    end
  end
end
