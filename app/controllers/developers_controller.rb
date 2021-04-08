class DevelopersController < ApplicationController
  before_action :find_dev, only: %i[show]

  def show
    @bots = Bot.where(developer_id: @developer.id).order('created_at ASC')
    @posts = []
    for @b in @bots do
      p = Post.where(bot_id: @b.id).last()
      if !p.nil?
        @posts.push(p)
      end
    end
  end

  private

  def find_dev
    @developer = Developer.friendly.find(params[:id])
  end
end
