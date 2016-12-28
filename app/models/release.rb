class Release < ActiveRecord::Base

  belongs_to :series, inverse_of: :releases
  belongs_to :group, inverse_of: :releases

  validates :series, :title, :slug, :group, :released_at, presence: true
  validates :slug, uniqueness: true

  scope :in_series, -> (series_id) { where(series_id: series_id) }

  def self.slug_from_url(url)
    if matched = url.match(/#{ENV['short_url']}\/extnu\/([^\/]+)/)
      matched[1]
    end
  end

end
