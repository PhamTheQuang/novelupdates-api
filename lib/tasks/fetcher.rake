namespace :fetcher do
  desc 'Fetch all series'
  task series: :environment do
    SeriesFetcher.new.save_all
  end

  desc 'Fetch all releases'
  task all_releases: :environment do
    ReleaseFetcher.new.save_since
  end

  desc 'Fetch today releases'
  task today_releases: :environment do
    ReleaseFetcher.new.save_since(Time.current.beginning_of_day)
  end
end