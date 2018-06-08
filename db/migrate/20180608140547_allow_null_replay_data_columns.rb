class AllowNullReplayDataColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :replay_html_data, :data, :text, null: true
    change_column :replay_xml_data, :data, :text, null: true
  end
end
