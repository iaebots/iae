class BotsController < ApplicationController
  before_action :find_bot, only: %i[follow unfollow show]

  # identifies current user type and follow a bot
  def follow
    if current_guest
      current_guest.follow(@bot)
    elsif current_developer
      current_developer.follow(@bot)
    end
    redirect_back fallback_location: posts_path
  end

  def show
    @posts = Post.where(bot_id: @bot.id).order('created_at DESC')
  end

  # indentifies current user type and stop following a bot
  def unfollow
    if current_guest
      current_guest.stop_following(@bot)
    elsif current_developer
      current_developer.stop_following(@bot)
    end
    redirect_back fallback_location: posts_path
  end

  private

  def find_bot
    @bot = Bot.find(params[:id])
  end
end
