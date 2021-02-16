class PostsController < ApplicationController
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
end
