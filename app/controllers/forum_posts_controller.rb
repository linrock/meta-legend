class ForumPostsController < ApplicationController

  # page for creating new posts
  def new
  end

  # creates a forum post
  def create
    forum_post = @user.forum_posts.new(forum_post_params)
    if forum_post.valid?
      forum_post.save!
      redirect_to "/forum"
    else
      redirect_back fallback_location: forum_path
    end
  end

  def show
    @forum_post = ForumPost.find(params[:id])
  end

  def forum_post_params
    params.require(:forum_post).permit(:title, :content)
  end
end
