require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :engineer }
  end
end
