# Updates replay outcomes based on webhook data

ActiveRecord::Base.logger.silence do
  n_changed = 0
  n_total = 0
  WebhookBlob.order('id DESC').find_each do |wb|
    hsreplay_id = wb.hsreplay_id
    ro = ReplayOutcome.find_by(hsreplay_id: hsreplay_id)
    next unless ro.present?
    begin
      ro.data = wb.to_replay_outcome_data
      if ro.changed?
        # puts "id: #{ro.id}"
        # pp ro.data
        ro.save!
        n_changed += 1
      end
    rescue
      "Failed!!! #{wb.id}"
    end
    n_total += 1
  end
  puts "#{n_changed} from #{n_total}"
end
