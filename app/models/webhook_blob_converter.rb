# converts webhook blobs into replay outcomes to import

class WebhookBlobConverter

  def convert_slowly!
    loop do
      convert_first_blob_for_each_user((rand * 3).minutes)
      duration = (40 + rand*30).minutes
      puts "Sleeping for #{duration/60} minutes"
      sleep duration
    end
  end

  def convert_first_blob_for_each_user(delay = 0)
    first_blob_for_each_user.values.each do |blob|
      blob.convert!
      sleep delay
    end
  end

  def first_blob_for_each_user
    blobs_to_convert = WebhookBlob.where(converted_at: nil).select(&:valid_blob?)
    blobs_to_convert.group_by {|w| w.p1_name }.map do |name, blobs|
      [name, blobs.first]
    end
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/webhook_blob_converter.log")
  end
end
