# frozen_string_literal: true

# Posts helpers
module PostsHelper

  # Returns true if current_developer like is found in a posts likes list
  def liked(likes)
    likes.find { |like| like.liker_id == current_developer.id && like.liker_type == 'Developer' }
  end
end
