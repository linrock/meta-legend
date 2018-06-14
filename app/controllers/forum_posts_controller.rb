class ForumPostsController < ApplicationController
  before_action :set_title_and_meta_desc

  # page for creating new posts
  def new
  end

  # creates a forum post
  def create
    forum_post = @user.forum_posts.new(forum_post_params)
    if forum_post_params[:post_type] == "legend" and !@user.is_legend?
      redirect_back fallback_location: forum_path
      return
    end
    if forum_post.valid?
      forum_post.save!
      redirect_to "/forum"
    else
      redirect_back fallback_location: forum_path
    end
  end

  def show
    @forum_post = ForumPost.find(params[:id])
    @title = "#{@forum_post.title} | Forum | Meta Legend"
  end

  def forum_post_params
    params.require(:forum_post).permit(:title, :content, :post_type)
  end

  private

  def set_title_and_meta_desc
    @title = "Forum | Meta Legend"
    @meta_desc = "Find legend-rank Hearthstone replays and players. Learn how the best players play the top decks."
  end
end
