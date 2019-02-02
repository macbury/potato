class CreateWebHooks < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'

    create_table :web_hooks, id: :uuid do |t|
      t.references :project, foreign_key: true
      t.string :secret

      t.timestamps
    end

    remove_column :projects, :secret
  end
end
