class Review < ApplicationRecord
  enum state: [
    :commented,
    :approved,
    :changes_requested,
    :dismissed,
  ]

  validates_presence_of :author
  validates :github_id, presence: true, uniqueness: true

  belongs_to :author, foreign_key: 'author_id', class_name: 'Engineer'
  belongs_to :pull_request
end
