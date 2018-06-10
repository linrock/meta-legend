class ForumController < ApplicationController
  FORUM_POST_LIMIT = 5

  def index
    @forum_posts = ForumPost.all.order('updated_at DESC').limit(FORUM_POST_LIMIT)
    @has_more = ForumPost.count > FORUM_POST_LIMIT
  end

  def show
    @forum_posts = ForumPost.all.order('updated_at DESC')
  end
end
