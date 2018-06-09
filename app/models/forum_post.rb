class ForumPost < ApplicationRecord
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :content
end
