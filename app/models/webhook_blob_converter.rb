# converts webhook blobs into replay outcomes to import

class WebhookBlobConverter

  def reconvert_recent!
    n_changed = 0
    n_total = 0
    replay_data_cache = ReplayDataCache.new
    WebhookBlob.order('id DESC').limit(10000).each do |wb|
      hsreplay_id = wb.hsreplay_id
      ro = ReplayOutcome.find_by(hsreplay_id: hsreplay_id)
      next unless ro.present?
      ro.data = wb.to_replay_outcome_data
      if ro.changed?
        puts "id: #{ro.id}"
        pp ro.data
        ro.save!
        ro.extract_and_save_data
        replay_data_cache.replay_data_hash! ro.hsreplay_id
        n_changed += 1
      end
      n_total += 1
    end
    puts "#{n_changed} from #{n_total}"
  end

  # convert all submitted webhook blobs while waiting between conversions
  def convert_slowly
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
    end
  end

  def first_blob_for_each_user
    blobs_to_convert = WebhookBlob.unconverted.select(&:valid_blob?).shuffle
    blobs_to_convert.group_by {|w| w.p1_name }.map do |name, blobs|
      [name, blobs.first]
    end
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/webhook_blob.log")
  end
end
