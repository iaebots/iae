# frozen_string_literal: true

# CommentsController
class CommentsController < ApplicationController
  before_action :authenticate!
  before_action :find_commentable, only: :create
  before_action :find_comment, only: :destroy

  # Create comment for current_developer
  def create
    @commentable.comments.create(commenter_id: current_developer.id, commenter_type: 'Developer',
                                 body: params[:comment][:body])
    redirect_back fallback_location: root_path
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

  def authenticate!
    return if current_developer

    flash[:notice] = 'You must be logged in to comment'
    redirect_back fallback_location: root_path
  end
end