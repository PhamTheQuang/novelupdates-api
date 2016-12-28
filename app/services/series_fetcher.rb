class SeriesFetcher
  BASE_URL = "#{ENV['base_url']}/series/page/"

  def initialize(url = BASE_URL)
    @url = url
  end

  def all
    document = get_page(1)
    total_page = total_page(document)

    series = parse_document(document)
    (total_page - 1).times.each do |page|
      document = get_page(page + 2)
      series.update(parse_document(document))
    end

    series
  end

  def save_all
    series_data = all
    existed_series = Series.where(slug: series_data.keys)

    Series.transaction do
      existed_series.each do |series|
        series.update_attributes(series_data[series.slug])
      end

      new_slugs = series_data.keys - existed_series.pluck(:slug)
      new_slugs.each do |slug|
        Series.create(series_data[slug])
      end
    end
  end

  private

  def get_page(page)
    rep = HTTParty.get("#{@url}#{page}")
    Nokogiri::HTML(rep.body)
  end

  def parse_document(document)
    parsed_document = {}
    document.css('.w-blog-entry-h').each do |entry|
      url = entry.css('.w-blog-entry-link').first.try(:[], 'href')
      slug = Series.slug_from_url(url)
      title = entry.css('.w-blog-entry-title').first.try(:content).try(:strip)
      parsed_document[slug] = { slug: slug, title: title }
    end

    parsed_document
  end

  def total_page(document)
    document.css('a.page-numbers:not(.next)').last.try(:content).to_i
  end
end