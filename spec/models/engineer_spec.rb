require 'rails_helper'

RSpec.describe Engineer, type: :model do
  it { is_expected.to validate_presence_of(:login) }
end