require 'rails_helper'

RSpec.describe Series, type: :model do

  it { is_expected.to have_many(:releases) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_uniqueness_of(:slug) }

  describe '#url' do
    let(:series) { build(:series, slug: 'my-slug') }

    subject { series.url }

    it { is_expected.to eq "#{ENV['base_url']}/series/my-slug/" }
  end

  describe '#usr=' do
    let(:series) { build(:series) }
    let(:slug) { 'new-slug' }
    let(:url) { "#{ENV['base_url']}/series/#{slug}/" }

    it 'updates the slug' do
      expect{ series.url = url }.to change{ series.slug }.to(slug)
    end
  end

  describe '.slug_from_url' do
    it { expect(described_class.slug_from_url("#{ENV['base_url']}/series/my-slug/")).to eq 'my-slug' }
  end
end
