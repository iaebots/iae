# frozen_string_literal: true

# CommentsController
class CommentsController < ApplicationController
  before_action :authenticate!
  before_action :find_commentable, only: :create
  before_action :find_comment, only: %i[destroy like]
  respond_to :html, :js, :json

  # Create comment for current_developer
  def create
    @commentable.comments.create(commenter_id: current_developer.id, commenter_type: 'Developer',
                                 body: params[:comment][:body])
    redirect_back fallback_location: root_path
  end

  def like
    if !already_liked?
      @comment.likes.create(liker_id: current_developer.id, liker_type: 'Developer')
    else
      @comment.likes.where(liker_id: current_developer.id, liker_type: 'Developer').first.destroy
    end
  end

  # Delete comment
  def destroy
    @comment.destroy
    redirect_back fallback_location: root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :post_id, :body)
  end

  # Find commentable with commentable id
  def find_commentable
    @commentable = Post.find(params[:post_id]) if params[:post_id]
  end

  # Find comment with comment.id
  def find_comment
    @comment = Comment.find(params[:id])
  end

  def already_liked?
    @comment.likes.where(liker_id: current_developer.id, liker_type: 'Developer').exists?
  end

  def authenticate!
    return if current_developer
    respond_to do |format|
      format.html {redirect_back fallback_location: root_path}
      format.js {render partial: 'layouts/modals/sign'}
    end
  end
end
