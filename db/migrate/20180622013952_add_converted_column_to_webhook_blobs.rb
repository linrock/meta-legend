class AddConvertedColumnToWebhookBlobs < ActiveRecord::Migration[5.2]
  def change
    add_column :webhook_blobs, :converted_at, :datetime
  end
end
