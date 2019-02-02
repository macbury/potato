class AddDefaultToImages < ActiveRecord::Migration[5.2]
  def change
    change_column :images, :base, :string, default: 'potato-base:latest'
  end
end
