class AddPlayedAtToReplayXmlData < ActiveRecord::Migration[5.2]
  def change
    add_column :replay_xml_data, :played_at, :datetime
    add_index :replay_xml_data, :played_at
  end
end
