class CreatePullRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :pull_requests, id: :uuid do |t|
      t.string :title
      t.integer :number, unique: true
      t.string :url
      t.string :repo
      t.integer :state, default: 0
      t.timestamp :awaiting_review_since

      t.references :author, references: :engineers, type: :uuid
      t.references :reviewer, references: :engineers, type: :uuid
      t.timestamps
    end

    add_foreign_key :pull_requests, :engineers, index: true, column: :author_id
    add_foreign_key :pull_requests, :engineers, index: true, column: :reviewer_id
  end
end
