class PullRequest < ApplicationRecord
  enum state: [
    :in_progress,
    :review_ready,
    :in_review,
    :does_not_need_review,
  ]

  validates_presence_of :author, :title
  validates :github_id, presence: true, uniqueness: true
  validates :number,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 },
            allow_nil: false

  belongs_to :author, foreign_key: 'author_id', class_name: 'Engineer'
  belongs_to :reviewer,
              foreign_key: 'reviewer_id',
              class_name: 'Engineer',
              optional: true

  def mark_as_review_ready
    transition all_states - [:review_ready] => :review_ready
  end

  def unmark_as_review_ready
    transition_success = transition review_ready: :in_progress
  end

  def open_pr
    transition all_states - [:in_progress] => :in_progress
  end

  def close_pr
    transition all_states - [:does_not_need_review] => :does_not_need_review
  end

  def assign
    transition all_states - [:in_review] => :in_review
  end

  def unassign
    transition_success = transition in_review: :review_ready
    update(reviewer: nil) if transition_success
  end

  def transition(transition)
    from = transition.keys.first
    to = transition.values.first

    return false unless [from].flatten.include? state.to_sym

    update!(
      state: to.to_sym,
      awaiting_review_since: to == :review_ready ? Time.now : nil
    )
  end

  def all_states
    self.class.states.keys.map(&:to_sym)
  end
end
