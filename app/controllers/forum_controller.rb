class ForumController < ApplicationController
  FORUM_POST_LIMIT = 5

  before_action :set_title_and_meta_desc

  def index
    @forum_posts = ForumPost.all.order('updated_at DESC').limit(FORUM_POST_LIMIT)
    @has_more = ForumPost.count > FORUM_POST_LIMIT
  end

  def show
    @forum_posts = ForumPost.all.order('updated_at DESC')
    @title = "General Discussion | Forum | Meta Legend"
  end

  private

  def set_title_and_meta_desc
    @title = "Forum | Meta Legend"
    @meta_desc = "Find legend-rank Hearthstone replays and players. Learn how the best players play the top decks."
  end
end
