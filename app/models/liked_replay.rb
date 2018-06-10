class LikedReplay < ApplicationRecord
  belongs_to :user
  validates_presence_of :hsreplay_id
end
