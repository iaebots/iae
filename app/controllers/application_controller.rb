# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  # Set locale for current user
  # Tries to get locale from user's preferences. Then, from user's browser locale
  # and, if both fails, sets to default locale (en).
  def set_locale
    I18n.locale = current_developer.try(:locale) || http_accept_language
                  .compatible_language_from(I18n.available_locales) || I18n.default_locale
  end
end
