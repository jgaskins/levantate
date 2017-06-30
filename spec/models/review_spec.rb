require 'rails_helper'

RSpec.describe Review, type: :model do
  review_states = [:commented, :approved, :changes_requested, :dismissed]
  let(:review) { Fabricate(:review) }

  context 'associations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:pull_request) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:github_id) }
    it { is_expected.to validate_uniqueness_of(:github_id) }
  end
end
