class ForumComment < ApplicationRecord
  belongs_to :forum_post
  belongs_to :user

  validates_presence_of :forum_post_id
  validates_presence_of :user_id
  validates_presence_of :content

  after_save :touch_forum_post

  def touch_forum_post
    forum_post.touch
  end
end
