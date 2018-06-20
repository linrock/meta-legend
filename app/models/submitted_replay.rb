class SubmittedReplay < ApplicationRecord
  before_validation :strip_hsreplay_id
  validates :hsreplay_id, presence: true

  def strip_hsreplay_id
    return unless self.hsreplay_id.present?
    self.hsreplay_id = self.hsreplay_id.strip
  end
end
