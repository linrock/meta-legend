# Converts webhook blobs into replay outcomes

class WebhookBlobConverterJob
  include Sidekiq::Worker

  sidekiq_options queue: :default, backtrace: true

  def perform(webhook_blob_id)
    blob = WebhookBlob.find_by(id: webhook_blob_id)
    return unless blob.present?
    blob.convert!
  end
end
