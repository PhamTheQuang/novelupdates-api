require 'rails_helper'

RSpec.describe SeriesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }

  describe 'GET index' do
    let!(:series) { create_list(:series, 2) }
    let(:expected_result) { JSON.parse(series.to_json) }

    it 'returns all series' do
      get :index

      expect(response_body).to match_array(expected_result)
    end
  end
end
