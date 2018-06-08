class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :battletag, null: false
      t.string :uid, null: false
      t.string :region
      t.jsonb :auth_hash, null: false
      t.timestamps
    end
    add_index :users, :battletag, unique: true
  end
end
