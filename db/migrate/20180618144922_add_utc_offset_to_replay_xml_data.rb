class AddUtcOffsetToReplayXmlData < ActiveRecord::Migration[5.2]
  def change
    add_column :replay_xml_data, :utc_offset, :integer
  end
end
