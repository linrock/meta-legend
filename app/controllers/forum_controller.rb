class ForumController < ApplicationController
  def index
    @forum_posts = ForumPost.all
  end
end
