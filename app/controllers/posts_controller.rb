# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[index]
  before_action :set_post, only: %i[show destroy]

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

  def destroy
    @post.destroy
    redirect_to request.referer
  end

  respond_to do |format|
    format.html
    format.js
  end

  private

  def authenticate!
    redirect_back fallback_location: root_path unless current_developer
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
