class CreateReplayHtmlData < ActiveRecord::Migration[5.2]
  def change
    create_table :replay_html_data do |t|
      t.string :hsreplay_id, null: false
      t.text :data, null: false
      t.jsonb :extracted_data
      t.timestamps
    end
    add_index :replay_html_data, :hsreplay_id, unique: true
  end
end
