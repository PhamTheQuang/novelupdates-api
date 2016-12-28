class ReleaseFetcher
  BASE_URL = "#{ENV['base_url']}/"

  def initialize(url = BASE_URL)
    @url = url
  end

  def since(time = nil)
    page = 1
    document = get_page(1)
    total_page = total_page(document)
    releases = {}

    while page <= total_page
      document = get_page(page)

      if in_time?(document, time)
        releases.update(parse_document(document))
        page += 1
      else
        break
      end
    end

    releases
  end

  def save_since(time = nil)
    Release.transaction do
      releases_data = since(time)
      releases_slugs = releases_data.keys
      new_release_slug = releases_slugs - Release.where(slug: releases_slugs).pluck(:slug)
      new_release_slug.each do |slug|
        release = Release.create(releases_data[slug])
        logger.warning("Unable to create release: #{release.to_json}") unless release
      end
    end
  end

  private

  def logger
    @logger ||= Rails.logger
  end

  def total_page(document)
    document.css(".digg_pagination a:not([rel='next'])").last.try(:content).to_i
  end

  def get_page(page)
    rep = HTTParty.get("#{@url}", query: { pg: page })
    Nokogiri::HTML(rep.body)
  end

  def parse_document(document)
    released_dates = document.css('.l-content.release > b').map { |e| Time.zone.parse(e.content) }
    releases = {}
    document.css('.tablesorter').each_with_index do |table, index|
      released_date = released_dates[index]

      table.css('tbody tr').each do |release|
        series_element = release.css('td:first-child a').first
        release_element = release.css('td:nth-child(2) a.chp-release').first
        group_element = release.css('td:nth-child(3) a').first

        if (series_element && release_element && group_element)
          series_url = series_element['href']
          series_title = series_element.content
          series_slug = Series.slug_from_url(series_url)
          series = Series.where(slug: series_slug).first_or_create(title: series_title)
          logger.warning("Unable to create series: #{series.to_json}") unless series

          group_url = group_element['href']
          group_title = group_element.content
          group_slug = Group.slug_from_url(group_url)
          group = Group.where(slug: group_slug).first_or_create(title: group_title)
          logger.warning("Unable to create group: #{group.to_json}") unless group

          release_url = release_element['href']
          release_title = release_element.content
          release_slug = Release.slug_from_url(release_url)

          releases[release_slug] = {
            url: release_url,
            title: release_title,
            slug: release_slug,
            series: series,
            group: group,
            released_at: released_date
          }
        end
      end
    end

    releases
  end

  def in_time?(document, time)
    return true unless time

    if document_date = document.css('.l-content.release > b').first.try(:content)
      Time.zone.parse(document_date).beginning_of_day >= time.beginning_of_day
    end
  end
end