class PostsController < ApplicationController
  before_action :authenticate!, only: %[index]

  def index
    if current_developer
      @posts = Post.joins("JOIN Follows f ON posts.bot_id = f.followable_id
	                         JOIN Developers d ON f.follower_id = d.id
                           WHERE f.follower_type ~* 'developer'")
                   .paginate(page: params[:page]).order('created_at DESC')
    elsif current_guest
      @posts = Post.joins("JOIN Follows f ON posts.bot_id = f.followable_id
	                          JOIN Guests g ON f.follower_id = g.id
                            WHERE f.follower_type ~* 'guest'")
                   .paginate(page: params[:page]).order('created_at DESC')
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  respond_to do |format|
    format.html
    format.js
  end

  private

  def authenticate!
    redirect_back fallback_location: root_path if !current_guest && !current_developer
  end
end
