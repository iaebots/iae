# frozen_string_literal: true

module Guests
  class RegistrationsController < Devise::RegistrationsController
    include Accessible
    before_action :configure_sign_up_params, only: %i[create]
    before_action :configure_account_update_params, only: %i[update]
    skip_before_action :check_user, only: %i[edit update cancel]
    after_action :save_user_timezone, only: :create

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    # def create
    #   super
    # end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    private

    # Save user's timezone on sign-up
    def save_user_timezone
      return unless resource.persisted?

      resource.update(timezone: cookies[:timezone])
    end

    protected

    # Permitted params for guests sign-up
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email password password_confirmation remember_me])
    end

    # Permitted params for guests update
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[username email password password_confirmation locale
                                                                  timezone])
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
