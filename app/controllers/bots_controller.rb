# frozen_string_literal: true

# BotsController
class BotsController < ApplicationController
  before_action :find_bot, only: %i[follow show destroy regenerate_keys edit update]
  before_action :confirmed?, only: %i[new]
  after_action :verify_bot, only: :create
  before_action :authenticate!, except: %i[show confirmation_modal]
  respond_to :html, :js, :json

  def show
    @posts = Post.where(bot_id: @bot.id).paginate(page: params[:page], per_page: 5).order('created_at DESC')
  end

  # Follow and unfollow a bot
  def follow
    if !@bot.followed_by?(current_developer)
      current_developer.follow(@bot)
    else
      current_developer.stop_following(@bot)
    end
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  def new
    if !current_developer.verified? && current_developer.bots.count >= 5
      flash[:notice] = I18n.t('bots.registrations.new.limit')
      redirect_back fallback_location: developer_path(current_developer)
    else
      @bot = Bot.new
    end
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
    redirect_to developer_path(current_developer)
  end

  # Regenerate API keys
  def regenerate_keys
    @bot.api_key = Bot.generate_api_key
    @bot.api_secret = Bot.generate_api_secret
    @bot.update_attribute(:api_key, @bot.api_key)
    @bot.update_attribute(:api_secret, @bot.api_secret)

    redirect_to developer_path(@bot.developer)
  end

  def search
    respond_to do |format|
      format.js {}
    end
  end

  private

  def find_bot
    @bot = Bot.friendly.find(params[:id])
  end

  def bot_params
    params.require(:bot).permit(:name, :username, :bio, :developer_id, :tag_list, :avatar, :cover, :repository, :slug)
  end

  def confirmed?
    return if current_developer&.confirmed?

    flash[:notice] = I18n.t('bots.registrations.new.email_confirmation')
    redirect_to developer_path(current_developer)
  end

  def verify_bot
    @bot.update_attribute(:verified, true) if @bot.developer.verified?
  end

  def authenticate!
    return if current_developer

    @action = I18n.t("application.alert.#{action_name}")
    @icon = if action_name == 'follow'
              'fa fa-user-friends'
            else
              'fas fa-sign-in-alt'
            end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js { render partial: 'layouts/modals/sign' }
    end
  end
end
