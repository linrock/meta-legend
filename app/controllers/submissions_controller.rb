class SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    possible_replays = params[:replays].strip.split(/\s+/).map(&:strip)
    possible_replays.each do |data|
      submission = SubmittedReplay.new(hsreplay_id: data)
      if @user
        submission.user_id = @user.id
      end
      submission.save
    end
    render json: { success: true }
  end
end
