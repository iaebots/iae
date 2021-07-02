class LikesController < ApplicationController
  before_action :authenticate!
  before_action :find_post
  before_action :find_like, only: %i[destroy]

  # like post or unlike it if it's already liked
  def create
    @post.likes.create(developer_id: current_developer.id) unless already_liked?
    redirect_back fallback_location: root_path
  end

  # deletes like
  def destroy
    @like.destroy if already_liked?
    redirect_back fallback_location: root_path
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def find_like
    @like = @post.likes.find_by(developer_id: current_developer.id)
  end

  def already_liked?
    Like.where(developer_id: current_developer.id, post_id: params[:post_id]).exists?
  end

  # check if there is a current user
  def authenticate!
    return if current_developer

    flash[:notice] = 'You must be logged in to like'
    redirect_back fallback_location: root_path
  end
end
