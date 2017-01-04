require 'rails_helper'

RSpec.describe ReleasesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }

  describe 'GET index' do
    let!(:releases) { create_list(:release, 3) }
    let(:expect_result) do
      JSON.parse({
        releases: return_releases.sort { |x, y| y.released_at <=> x.released_at },
        page: 1,
        total_count: return_releases.count
        }.to_json)
    end

    context 'When without filter' do
      let(:return_releases) { releases }

      it 'returns all releases' do
        get :index, format: :json

        expect(response_body).to eq(expect_result)
      end
    end

    context 'When with series filter' do
      let(:release) { releases.sample }
      let(:return_releases) { [release] }

      it 'returns releases of the series' do
        get :index, series: release.series, format: :json

        expect(response_body).to eq(expect_result)
      end
    end
  end
end