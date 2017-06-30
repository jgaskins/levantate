require 'rails_helper'

RSpec.describe PullRequest, type: :model do
  pr_states = [:in_progress, :review_ready, :in_review, :does_not_need_review]

  let(:state) { :in_progress }
  let(:awaiting_review_since) { nil }
  let(:pr) do
    Fabricate(:pull_request, state: state,
              awaiting_review_since: awaiting_review_since)
  end

  context 'associations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:reviewer) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to_not allow_values(nil).for(:number) }
    it {
      is_expected.to validate_numericality_of(:number)
        .is_greater_than_or_equal_to(1)
        .only_integer
    }
  end

  describe '#mark_as_review_ready' do
    subject(:mark_as_review_ready) { pr.mark_as_review_ready }

    [:in_progress, :in_review, :does_not_need_review].each do |s|
      context "when #{s.to_s}" do
        let(:state) { s }

        it 'should set to :review_ready' do
          expect { mark_as_review_ready }.to change{ pr.state }.to 'review_ready'
        end

        it 'should set awaiting_review_since' do
          expect { mark_as_review_ready }
            .to change{ pr.awaiting_review_since }
            .from(nil)
        end
      end
    end

    context 'when :review_ready' do
      let(:state) { :review_ready }
      let(:awaiting_review_since) { Time.now }

      it 'should not change state' do
        expect { mark_as_review_ready }.not_to change { pr.state }
      end

      it 'should not change awaiting_review_since' do
        expect { mark_as_review_ready }.not_to change { pr.awaiting_review_since }
      end
    end
  end

  describe '#unmark_as_review_ready' do
    subject(:unmark_as_review_ready) { pr.unmark_as_review_ready }

    context 'unacceptable states' do
      states = pr_states - [:review_ready]
      unchanged_attributes = ['"state"', '"awaiting_review_since"']

      include_examples 'unacceptable_state_events', states, unchanged_attributes
    end

    context 'acceptable states' do
      let(:awaiting_review_since) { Time.now }

      states = [:review_ready]
      changed_attributes = ['"state"', '"awaiting_review_since"']
      additional_specs = {
        awaiting_review_since: { to: nil },
        state:  { to: 'in_progress' },
      }

      include_examples 'acceptable_state_events', states, changed_attributes, additional_specs
    end
  end

  describe '#approve' do
    subject(:approve) { pr.approve }

    context 'unacceptable states' do
      states = [:merge_ready]
      unchanged_attributes = ['"state"', '"awaiting_review_since"']

      include_examples 'unacceptable_state_events', states, unchanged_attributes
    end

    context 'acceptable states' do
      states = pr_states - [:merge_ready]
      changed_attributes = ['"state"']
      additional_specs = { state: { to: 'merge_ready' } }

      include_examples 'acceptable_state_events', states, changed_attributes, additional_specs
    end
  end

  describe '#open_pr' do
    subject(:open_pr) { pr.open_pr }

    context 'unacceptable states' do
      states = [:in_progress]
      unchanged_attributes = ['"state"', '"awaiting_review_since"']

      include_examples 'unacceptable_state_events', states, unchanged_attributes
    end

    context 'acceptable states' do
      states = pr_states - [:in_progress]
      changed_attributes = ['"state"']
      additional_specs = { state: { to: 'in_progress' } }

      include_examples 'acceptable_state_events', states, changed_attributes, additional_specs
    end
  end

  describe '#close_pr' do
    subject(:close_pr) { pr.close_pr }

    context 'unacceptable states' do
      states = [:does_not_need_review]
      unchanged_attributes = ['"state"', '"awaiting_review_since"']

      include_examples 'unacceptable_state_events', states, unchanged_attributes
    end

    context 'acceptable states' do
      states = pr_states - [:does_not_need_review]
      changed_attributes = ['"state"']
      additional_specs = { state: { to: 'does_not_need_review' } }

      include_examples 'acceptable_state_events', states, changed_attributes, additional_specs
    end
  end

  describe '#assign' do
    subject(:assign) { pr.assign }

    context 'unacceptable states' do
      states = [:in_review]
      unchanged_attributes = ['"state"', '"awaiting_review_since"']

      include_examples 'unacceptable_state_events', states, unchanged_attributes
    end

    context 'acceptable states' do
      states = pr_states - [:in_review]
      changed_attributes = ['"state"']
      additional_specs = { state: { to: 'does_not_need_review' } }

      include_examples 'acceptable_state_events', states, changed_attributes, additional_specs
    end
  end

  describe '#unassign' do
    subject(:unassign) { pr.unassign }

    context 'unacceptable states' do
      states = pr_states - [:in_review]
      unchanged_attributes = ['"state"', '"awaiting_review_since"']

      include_examples 'unacceptable_state_events', states, unchanged_attributes
    end

    context 'acceptable states' do
      states = [:in_review]
      changed_attributes = ['"state"']
      additional_specs = { state: { to: 'does_not_need_review' } }

      include_examples 'acceptable_state_events', states, changed_attributes, additional_specs
    end
  end

  describe '#transition' do
    pending '#transition Tests'
  end

  describe '#all_states' do
    pending '#all_states tests'
  end
end
