class AddGithubIdsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_id, :integer
    add_column :users, :name, :string
  end
end
