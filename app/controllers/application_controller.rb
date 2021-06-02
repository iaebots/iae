# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  # Returns current user whether it's a guest or a developer
  def current_user
    current_developer || current_guest
  end

  protected

  # Permit username and name as strong parameters for Devise Sign-up
  def configure_permitted_parameters
    added_attrs = %i[name username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  # Set locale for current user
  # Tries to get locale from user's preferences. Then, from user's browser locale
  # and, if both fails, sets to default locale (en).
  def set_locale
    I18n.locale = current_user.try(:locale) || http_accept_language.compatible_language_from(I18n.available_locales) ||
                  I18n.default_locale
  end
end
