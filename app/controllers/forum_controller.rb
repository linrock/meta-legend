class ForumController < ApplicationController
  FORUM_POST_LIMIT = 5

  before_action :set_title_and_meta_desc

  def index
    @general_posts = ForumPost.general_posts.order('updated_at DESC').limit(FORUM_POST_LIMIT)
    @user_is_legend = @user.present? && @user.is_legend?
    if @user_is_legend
      @legend_posts = ForumPost.legend_posts.order('updated_at DESC').limit(FORUM_POST_LIMIT)
    end
    @has_more = ForumPost.count > FORUM_POST_LIMIT
  end

  def general_discussion
    @forum_posts = ForumPost.general_posts.order('updated_at DESC')
    @title = "General Discussion | Forum | Meta Legend"
  end

  def legend_lounge
    @forum_posts = ForumPost.legend_posts.order('updated_at DESC')
    @title = "Legend Lounge | Forum | Meta Legend"
  end

  private

  def set_title_and_meta_desc
    @title = "Forum | Meta Legend"
    @meta_desc = "Find legend-rank Hearthstone replays and players. Learn how the best players play the top decks."
  end
end
