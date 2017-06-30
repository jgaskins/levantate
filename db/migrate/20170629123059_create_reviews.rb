class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :state, default: 0
      t.string :github_id, unique: true
      t.string :url
      t.text :body

      t.references :author, references: :engineers, type: :uuid
      t.references :pull_request, type: :uuid

      t.timestamp :submitted_at
      t.timestamps
    end

    add_foreign_key :reviews, :engineers, index: true, column: :author_id
    add_foreign_key :reviews, :pull_requests, index: true, column: :pull_request_id
  end
end
