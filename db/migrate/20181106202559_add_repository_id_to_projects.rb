class AddRepositoryIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :repository_id, :integer
  end
end
