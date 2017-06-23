class PullRequest < ApplicationRecord
  enum state: {
    in_progress: 0,
    review_ready: 1,
    in_review: 2,
    does_not_need_review: 3,
  }

  validates_presence_of :author, :title
  validates :number,
            presence: true,
            uniqueness: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 },
            allow_nil: false

  belongs_to :author, foreign_key: 'author_id', class_name: 'Engineer'
  belongs_to :reviewer, foreign_key: 'reviewer_id', class_name: 'Engineer'

  def mark_as_review_ready
    transition all_states - [:review_ready] => :review_ready
  end

  def unmark_as_review_ready
    transition review_ready: :in_progress
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
    transition in_review: :review_ready
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
