# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[index destroy like]
  before_action :set_post, only: %i[show destroy like media_open]
  respond_to :html, :js, :json

  def index
    @posts = Post.joins("JOIN Follows f ON posts.bot_id = f.followable_id
                          WHERE f.follower_type ~* 'developer'
                          AND (CURRENT_TIMESTAMP - posts.created_at) < INTERVAL '1 day'
                          AND f.follower_id = #{current_developer.id}")
                 .paginate(page: params[:page]).order('created_at DESC')
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
    redirect_to root_path
  end

  def media_open
    respond_to do |format|
      format.html { redirect_to(@post.media_url(:desktop) || @post.media_url) }
      format.js {}
    end
  end

  private

  def authenticate!
    return if current_developer

    @icon = if action_name == 'like'
              'fas fa-heart'
            else
              'fas fa-sign-in-alt'
            end

    @action = I18n.t("application.alert.post-#{action_name}")
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js { render partial: 'layouts/modals/sign' }
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def already_liked?
    @post.likes.where(liker_id: current_developer.id, liker_type: 'Developer').exists?
  end
end
