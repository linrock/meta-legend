class ForumCommentsController < ApplicationController

  def create
    unless @user
      redirect_back fallback_location: forum_path
      return
    end
    forum_post = ForumPost.find(params[:id])
    forum_comment = forum_post.forum_comments.new(
      forum_comment_params.merge({ user_id: @user.id })
    )
    if forum_comment.valid?
      forum_comment.save!
      redirect_to "/forum/posts/#{params[:id]}"
    else
      binding.pry
      redirect_back fallback_location: forum_path
    end
  end

  def forum_comment_params
    params.require(:forum_comment).permit(:content)
  end
end
