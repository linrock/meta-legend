class ForumController < ApplicationController
  def index
    @forum_posts = ForumPost.all
  end

  # creates a forum post
  def create
    @user.forum_posts.create!(forum_post_params)
    redirect_to "/forum"
  end

  def forum_post_params
    params.require(:forum_post).permit(:title, :content)
  end
end
