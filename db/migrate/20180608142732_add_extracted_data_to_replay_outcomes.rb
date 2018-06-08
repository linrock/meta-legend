class AddExtractedDataToReplayOutcomes < ActiveRecord::Migration[5.2]
  def change
    add_column :replay_outcomes, :extracted_data, :jsonb
  end
end
