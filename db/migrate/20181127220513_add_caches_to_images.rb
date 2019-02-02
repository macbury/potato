class AddCachesToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :caches, :text, array: true, default: []
  end
end
