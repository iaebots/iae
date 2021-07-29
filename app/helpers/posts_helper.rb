# frozen_string_literal: true

# Posts helpers
module PostsHelper

  # Returns true if current_developer like is found in a posts likes list
  def liked(likes)
    likes.find { |like| like.liker_id == current_developer.id && like.liker_type == 'Developer' }
  end
  
  def time_ago(created_at)
    difference = Time.now.in_time_zone - created_at.in_time_zone
    if difference < 1.minute
      I18n.t('time.distance.x_seconds_ago', count: (difference / 1.second).to_i)
    elsif difference < 1.hour
      I18n.t('time.distance.x_minutes_ago', count: (difference / 1.minute).to_i)
    elsif difference < 1.day
      I18n.t('time.distance.x_hours_ago', count: (difference / 1.hour).to_i)
    elsif difference < 2.days
      I18n.l(created_at.in_time_zone, format: :yesterday)
    else
      I18n.l(created_at.in_time_zone, format: :date)
    end
  end
end
