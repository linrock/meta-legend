class ForumPost < ApplicationRecord
  belongs_to :user
  has_many :forum_comments

  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :content

  def forum_comments_count
    @forum_comments_count ||= forum_comments.count
  end
end
