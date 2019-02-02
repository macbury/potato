class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.integer :status, default: 0

      t.integer :owner_id
      t.string :owner_type

      t.integer :build_id

      t.text :command

      t.timestamps
    end
  end
end
