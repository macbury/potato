class AddTimesToBuilds < ActiveRecord::Migration[5.2]
  def change
    add_column :builds, :started_at, :datetime
    add_column :builds, :finished_at, :datetime
  end
end
