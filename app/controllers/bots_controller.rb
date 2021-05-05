class BotsController < ApplicationController
  before_action :find_bot, only: %i[follow unfollow show destroy regenerate_keys edit update]
  before_action :bot_params, only: %i[create]

  # Identifies current user type and follow a bot
  def follow
    if current_guest
      current_guest.follow(@bot)
    elsif current_developer
      current_developer.follow(@bot)
    end
    redirect_back fallback_location: posts_path
  end

  def show
    @posts = Post.where(bot_id: @bot.id).paginate(page: params[:page], per_page: 5).order('created_at DESC')
  end

  # Indentifies current user type and stop following a bot
  def unfollow
    if current_guest
      current_guest.stop_following(@bot)
    elsif current_developer
      current_developer.stop_following(@bot)
    end
    redirect_back fallback_location: posts_path
  end

  def new
    @bot = Bot.new
  end

  def create
    @bot = Bot.new(bot_params)

    if @bot.save
      redirect_to bot_path(@bot)
    else
      render 'new'
    end
  end

  def edit
    redirect_to bot_path(@bot) if !current_developer || (current_developer && @bot.developer != current_developer)
  end

  def update
    @bot.update(bot_params)
    if @bot.save
      @bot.update_attribute(:slug, @bot.username)
      redirect_to bot_path(@bot)
    else
      render 'edit'
    end
  end

  def destroy
    @bot.destroy
    redirect_to root_path
  end

  # Returns all bots that have tags that look like users' input
  def index
    if params[:input].present?
      @bots = Bot.find_by_sql("
        SELECT DISTINCT b.*
        FROM Bots b
        JOIN Taggings t ON t.taggable_id = b.id
        JOIN Tags ta ON ta.id = t.tag_id
        WHERE ta.name ~* '#{params[:input]}'
          OR b.username ~* '#{params[:input]}'")

      @developers = Developer.find_by_sql("
        SELECT *
        FROM Developers
        WHERE username ~* '#{params[:input]}'")
    end
  end

  # Regenerate API keys
  def regenerate_keys
    @bot.api_key = Bot.generate_api_key
    @bot.api_secret = Bot.generate_api_secret
    @bot.update_attribute(:api_key, @bot.api_key)
    @bot.update_attribute(:api_secret, @bot.api_secret)

    redirect_to developer_path(@bot.developer)
  end

  private

  def find_bot
    @bot = Bot.friendly.find(params[:id])
  end

  def bot_params
    params.require(:bot).permit(:name, :username, :bio, :developer_id, :tag_list, :avatar, :cover, :repository, :slug)
  end
end
