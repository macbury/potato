class CreateCommits < ActiveRecord::Migration[5.2]
  def change
    rename_column :builds, :revision, :sha
    add_column :builds, :branch, :string
    add_column :builds, :message, :string
    add_column :builds, :author_name, :string
    add_column :builds, :author_github_id, :string
  end
end
