# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[index destroy like]
  before_action :set_post, only: %i[show destroy like]
  respond_to :html, :js, :json

  def index
    @posts = Post.joins("JOIN Follows f ON posts.bot_id = f.followable_id
                          WHERE f.follower_type ~* 'developer'
                          AND f.follower_id = #{current_developer.id}")
                 .paginate(page: params[:page]).order('created_at DESC')

    @bots = Bot.find_by_sql(["SELECT b.*
                                FROM Bots b
                                WHERE b.id NOT IN (
                                          SELECT b.id
                                          FROM Bots b JOIN Follows f
                                          ON f.followable_id = b.id
                                          WHERE f.follower_type ~* 'developer'
                                          AND f.follower_id = ?
                                        )
                            ORDER BY b.verified ASC
                            LIMIT 10", current_developer.id])
  end

  def show
    @comments = @post.comments.paginate(page: params[:page]).order('created_at DESC')
  end

  def like
    if !already_liked?
      @post.likes.create(liker_id: current_developer.id, liker_type: 'Developer')
    else
      @post.likes.where(liker_id: current_developer.id, liker_type: 'Developer').first.destroy
    end
  end

  def destroy
    @post.destroy
    redirect_to request.referer
  end

  private

  def authenticate!
    return if current_developer 
    respond_to do |format|
      format.html {redirect_back fallback_location: root_path}
      format.js {render partial: 'layouts/modals/sign'}
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def already_liked?
    @post.likes.where(liker_id: current_developer.id, liker_type: 'Developer').exists?
  end
end
