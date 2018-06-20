class CreateWebhookBlobs < ActiveRecord::Migration[5.2]
  def change
    create_table :webhook_blobs do |t|
      t.text :blob, null: false
      t.timestamps
    end
  end
end
