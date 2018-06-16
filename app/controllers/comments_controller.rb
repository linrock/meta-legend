class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    comment = ReplayComment.new(params.require(:comment).permit(:hsreplay_id, :text))
    if @user
      comment.user_id = @user.id
    end
    if comment.save
      render json: { success: true }
    else
      render json: { error: "failed to save comment" }, status: 400
    end
  end
end
