class LikesController < ApplicationController
  before_action :authenticate!
  before_action :find_post
  before_action :find_like, only: %i[destroy]

  # like post or unlike it if it's already liked
  def create
    if !already_liked?
      if current_guest
        @post.likes.create(guest_id: current_user.id)
      else
        @post.likes.create(developer_id: current_user.id)
      end
    end
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
    if current_guest
      @like = @post.likes.find_by(guest_id: current_user.id)
    else
      @like = @post.likes.find_by(developer_id: current_user.id)
    end
  end

  def already_liked?
    if current_guest
      Like.where(guest_id: current_user.id, post_id: params[:post_id]).exists?
    else
      Like.where(developer_id: current_user.id, post_id: params[:post_id]).exists?
    end
  end

  # check if there is a current user
  def authenticate!
    if !current_developer && !current_guest
      flash[:notice] = 'You must be logged in to like'
      redirect_back fallback_location: root_path
    end
  end
end
