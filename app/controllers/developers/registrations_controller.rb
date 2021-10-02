# frozen_string_literal: true

module Developers
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: %i[create]
    before_action :configure_account_update_params, only: %i[update]
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
    def destroy
      resource.soft_delete
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message :notice, :destroyed
      yield resource if block_given?
      respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
    end

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

    # Permit avatar and cover for sign_up
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up,
                                        keys: %i[name username email password password_confirmation remember_me avatar
                                                 cover])
    end

    # Permit avatar cover for update
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update,
                                        keys: %i[name username email password password_confirmation avatar
                                                 cover bio locale timezone])
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
