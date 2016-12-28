class Series < ActiveRecord::Base

  has_many :releases, dependent: :destroy, inverse_of: :series

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true

  def url
    "#{ENV['base_url']}/series/#{slug}/"
  end

  def url=(url)
    self.slug = self.class.slug_from_url(url)
  end

  def self.slug_from_url(url)
    if matched = url.match(/#{ENV['short_url']}\/series\/([^\/]+)/)
      matched[1]
    end
  end
end
