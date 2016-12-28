require 'rails_helper'

RSpec.describe Release, type: :model do
  subject { described_class.new(released_at: Time.current) }

  it { is_expected.to belong_to(:series) }
  it { is_expected.to belong_to(:group) }
  it { is_expected.to validate_presence_of(:series) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:group) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_presence_of(:released_at) }
  it { is_expected.to validate_uniqueness_of(:slug) }

  describe '.in_series' do
    let!(:series) { create_list(:series, 3) }
    let!(:expected_releases) { expected_series.map{ |series| create(:release, series: series) } }
    let!(:other_releases) { (series - expected_series).map{ |series| create(:release, series: series) } }
    let(:expected_series) { series.sample(2) }

    it 'returns releases in the series' do
      expect(described_class.in_series(expected_series.map(&:id))).to match_array(expected_releases)
    end
  end

  describe '.slug_from_url' do
    it { expect(described_class.slug_from_url("#{ENV['base_url']}/extnu/my-slug/")).to eq 'my-slug' }
  end
end
