require 'rails_helper'

RSpec.describe ReleasesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }

  describe 'GET index' do
    let!(:releases) { create_list(:release, 3) }
    let(:expect_result) { JSON.parse(return_releases.to_json) }

    context 'When without filter' do
      let(:return_releases) { releases }

      it 'returns all releases' do
        get :index

        expect(response_body).to match_array(expect_result)
      end
    end

    context 'When with series filter' do
      let(:release) { releases.sample }
      let(:return_releases) { [release] }

      it 'returns releases of the series' do
        get :index, series: release.series

        expect(response_body).to match_array(expect_result)
      end
    end
  end
end