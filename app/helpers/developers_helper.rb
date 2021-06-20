# frozen_string_literal: true

# Helpers for Developers
module DevelopersHelper
  def created_at_formatted(created_at)
    I18n.l(created_at.in_time_zone, format: :date)
  end
end
