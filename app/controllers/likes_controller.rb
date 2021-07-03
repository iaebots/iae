# frozen_string_literal: true

# LikesController
class LikesController < ApplicationController
  before_action :authenticate!
  before_action :find_likeable
  before_action :find_like, only: %i[destroy]

  # Create a like on likeable model if it doesn't exist
  def create
    @likeable.likes.create!(liker_id: current_developer.id, liker_type: 'Developer') unless already_liked?
    redirect_back fallback_location: root_path
  end

  # Delete current_developer's like if it exists
  def destroy
    @like.destroy if already_liked?
    redirect_back fallback_location: root_path
  end

  private

  # Find likeable model based on params
  def find_likeable
    @likeable = if params[:post_id] && !params[:comment_id]
                  Post.find(params[:post_id])
                else
                  Comment.find(params[:comment_id])
                end
  end

  def find_like
    @like = @likeable.likes.where(liker_id: current_developer.id, liker_type: 'Developer').first
  end

  def already_liked?
    @likeable.likes.where(liker_id: current_developer.id, liker_type: 'Developer').exists?
  end

  # Return if there's a user signed in
  # Otherwise, show flash notice message
  def authenticate!
    return if current_developer

    flash[:notice] = 'You must be logged in to like'
    redirect_back fallback_location: root_path
  end
end
