class PagesController < ApplicationController
  def home
    @post = Post.where(media: nil).last()
  end
end
