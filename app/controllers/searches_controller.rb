# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :authenticate!, only: :search

  # Returns all bots that have tags that look like users' input
  def search
    return unless params[:input].present?

    @bots = Bot.find_by_sql(["
      SELECT DISTINCT b.* FROM Bots b
      JOIN Taggings t ON t.taggable_id = b.id
      JOIN Tags ta ON ta.id = t.tag_id
      WHERE ta.name ~* ? OR b.username ~* ?", params[:input], params[:input]])

    @developers = Developer.find_by_sql(["
      SELECT d.name, d.username, d.avatar_data, d.verified, d.slug, d.created_at, d.bio, d.id
      FROM Developers d
      WHERE username ~* ?", params[:input]])
  end

  def authenticate!
    return if current_developer

    redirect_to root_path
  end
end
