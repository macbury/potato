class AddTextStepsToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :build_script, :text, default: ''
    add_column :images, :setup_script, :text, default: ''
    add_column :pipelines, :script, :text, default: ''
  end
end
