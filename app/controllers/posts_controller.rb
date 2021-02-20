class PostsController < ApplicationController
  before_action :authenticate!

  def index
    @posts = Post.paginate(page: params[:page]).order('created_at DESC')
  end

  def show
    @post = Post.find(params[:id])
  end

  respond_to do |format|
    format.html
    format.js
  end

  private

  def authenticate!
    redirect_back fallback_location: root_path if !current_guest && !current_developer
  end
end
