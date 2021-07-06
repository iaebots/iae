# frozen_string_literal: true

# Developers general Controller
class DevelopersController < ApplicationController
  before_action :find_dev, only: %i[show]

  def show
    @bots = Bot.where(developer_id: @developer.id).order('created_at ASC')
    @posts = []
    @bots.each do |b|
      p = Post.where(bot_id: b.id).last
      @posts.push(p) unless p.nil?
    end
  end

  private

  def find_dev
    @developer = Developer.friendly.find(params[:id])
  end
end
