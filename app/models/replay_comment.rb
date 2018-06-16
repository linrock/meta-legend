class ReplayComment < ApplicationRecord
  validates_presence_of :hsreplay_id
  validates_presence_of :text
end
