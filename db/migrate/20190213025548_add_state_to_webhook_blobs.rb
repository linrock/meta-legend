class AddStateToWebhookBlobs < ActiveRecord::Migration[5.2]
  def change
    add_column :webhook_blobs, :state, :string
  end
end
