class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # returns current user whether it's a guest or a developer
  def current_user
    current_developer || current_guest
  end

  protected

  # adiciona username e name como parâmetros adicionais
  def configure_permitted_parameters
    added_attrs = %i[name username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
