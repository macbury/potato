class AddPrepareToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :trigger, :integer, default: 0
  end
end
