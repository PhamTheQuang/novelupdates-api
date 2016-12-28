require 'rails_helper'

RSpec.describe SeriesFetcher do
  let(:service) { described_class.new }

  describe '#all' do
    subject(:all) { service.all }

    it 'fetch all the series' do
      VCR.use_cassette("series") do
        expect(all.count).to eq 2166
        expect(all['konjiki-no-moji-tsukai']).to eq(
          slug: 'konjiki-no-moji-tsukai',
          title: 'Konjiki no Moji Tsukai'
        )
      end
    end
  end

  describe '#save_all' do
    let(:new_series_attr) { { slug: 'new_slug', title: 'New title' } }
    let(:existing_series_attr) { { slug: 'existing_slug', title: 'Existing title' } }
    let(:series_data) do
      {
        'new_slug' => new_series_attr,
        'existing_slug' => existing_series_attr
      }
    end
    let!(:existing_series) { create(:series, slug: 'existing_slug') }
    let(:new_series) { Series.last }

    before { allow(service).to receive(:all).and_return(series_data) }

    it 'creates new series and update existing series' do
      expect { service.save_all }.to change { Series.count }.by(1)
      expect(new_series).to have_attributes(new_series_attr)
      expect(existing_series.reload).to have_attributes(existing_series_attr)
    end
  end
end

