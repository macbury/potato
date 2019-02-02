class CreateBuilds < ActiveRecord::Migration[5.2]
  def change
    create_table :builds do |t|
      t.references :project, foreign_key: true
      t.integer :number
      t.integer :status, default: 0
      t.string :branch
      t.string :batch_id

      t.timestamps
    end
  end
end
