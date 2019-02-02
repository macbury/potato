class AddOutputToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :output, :text, array: true, default: []
  end
end
