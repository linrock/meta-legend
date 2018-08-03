# converts webhook blobs into replay outcomes to import

class WebhookBlobConverter

  def convert_slowly!
    loop do
      convert_first_blob_for_each_user(rand.minutes)
      duration = (5 + rand*5).minutes
      puts "Sleeping for #{duration/60} minutes"
      sleep duration
    end
  end

  def convert_first_blob_for_each_user(delay = 0)
    blobs = first_blob_for_each_user
    logger.info "Converting first blob for each user. #{blobs.length} total."
    blobs.map {|row| row[0] }.each do |name|
      logger.info name
    end
    blobs.map {|row| row[1] }.shuffle.each do |blob|
      blob.convert!
      sleep delay
    end
  end

  def first_blob_for_each_user
    blobs_to_convert = WebhookBlob.where(converted_at: nil).select(&:valid_blob?).shuffle
    blobs_to_convert.group_by {|w| w.p1_name }.map do |name, blobs|
      [name, blobs.first]
    end
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/webhook_blob.log")
  end
end
