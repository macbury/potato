class ChangeBranchToRevisionInBuilds < ActiveRecord::Migration[5.2]
  def change
    rename_column :builds, :branch, :revision
  end
end
