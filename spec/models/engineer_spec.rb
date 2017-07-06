require 'rails_helper'

RSpec.describe Engineer, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:login) }
  end

  context 'associations' do
    it { is_expected.to have_one :user }
  end
end
