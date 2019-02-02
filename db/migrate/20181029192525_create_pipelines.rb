class CreatePipelines < ActiveRecord::Migration[5.2]
  def change
    create_table :pipelines do |t|
      t.string :name
      t.references :project, foreign_key: true
      t.references :image, foreign_key: true

      t.timestamps
    end
  end
end
