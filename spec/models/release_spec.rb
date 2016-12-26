require 'rails_helper'

RSpec.describe Release, type: :model do
  it { is_expected.to belong_to(:series) }
  it { is_expected.to belong_to(:group) }
  it { is_expected.to validate_presence_of(:series) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:group) }
end
