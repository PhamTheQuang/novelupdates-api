require 'rails_helper'

RSpec.describe Group, type: :model do

  it { is_expected.to have_many(:releases) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_uniqueness_of(:slug) }

  describe '.slug_from_url' do
    it { expect(described_class.slug_from_url("#{ENV['base_url']}/group/my-slug/")).to eq 'my-slug' }
  end
end
