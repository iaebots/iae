class PagesController < ApplicationController
  def home
    @post = Post.last()
  end
end
