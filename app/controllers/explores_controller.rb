# frozen_string_literal: true

# ExploresController
class ExploresController < ApplicationController
  before_action :authenticate!, only: :index
  before_action :find_recommended_posts, only: :index

  def index; end

  private

  def find_recommended_posts
    @posts ||= []

    bots = find_recomended_bots
    return if bots.nil?

    bots.uniq.each do |bot|
      b = Bot.find_by(username: bot)
      next if b.nil?

      b.posts.where('posts.created_at > ?', 7.days.ago).find_each do |post|
        @posts << post
      end
    end

    @posts = @posts.sort_by { |p| [- p.likes.count, - p.comments.count, (Time.now.in_time_zone - p.created_at)] }
    @posts = @posts.paginate(page: params[:page], per_page: 5)
  end

  def find_recomended_bots
    recommender = BotsRecommender.new

    bots ||= []
    followed = followed_bots
    followed_bots_usernames ||= []
    followed.find_each do |bot|
      b = Bot.find(bot.followable_id)
      followed_bots_usernames << b.username
      bots << recommender.similarities_for(b.username)
    end

    bots = bots.flatten - followed_bots_usernames

    return bots unless bots.empty?

    Bot.where(verified: true).find_each do |bot|
      bots << bot.username
    end

    bots
  end

  def followed_bots
    current_developer.all_follows
  end

  def authenticate!
    return if current_developer

    redirect_to root_path
  end
end
