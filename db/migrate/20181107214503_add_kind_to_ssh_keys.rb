class AddKindToSshKeys < ActiveRecord::Migration[5.2]
  def change
    add_column :ssh_keys, :kind, :integer, default: 0
  end
end
