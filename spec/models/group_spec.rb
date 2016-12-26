require 'rails_helper'

RSpec.describe Group, type: :model do

  it { is_expected.to have_many(:releases) }
  it { is_expected.to validate_presence_of(:title) }
end
