class DevelopersController < ApplicationController
  before_action :find_dev, only: %i[show]

  def show
    @bots = Bot.where(developer_id: @developer.id).order('created_at ASC')
  end

  private

  def find_dev
    @developer = Developer.find(params[:id])
  end
end
