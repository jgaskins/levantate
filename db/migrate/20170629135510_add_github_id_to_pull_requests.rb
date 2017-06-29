class AddGithubIdToPullRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :pull_requests, :github_id, :string, unique: true
    change_column :pull_requests, :number, :string, unique: false
  end
end
