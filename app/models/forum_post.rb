class ForumPost < ApplicationRecord
  belongs_to :user
  has_many :forum_comments

  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :content
  validates :post_type, inclusion: %w( legend ), allow_blank: true

  scope :legend_posts, -> do
    where(post_type: "legend")
  end

  scope :general_posts, -> do
    where(post_type: nil)
  end

  def forum_comments_count
    @forum_comments_count ||= forum_comments.count
  end
end
