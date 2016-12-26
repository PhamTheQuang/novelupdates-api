require 'rails_helper'

RSpec.describe Series, type: :model do

  it { is_expected.to have_many(:releases) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_uniqueness_of(:slug) }
end
