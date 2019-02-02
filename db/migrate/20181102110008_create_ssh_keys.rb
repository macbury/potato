class CreateSshKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :ssh_keys do |t|
      t.string :public_key
      t.string :encrypted_private_key
      t.string :encrypted_private_key_iv
      t.string :fingerprint
      t.string :name
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
