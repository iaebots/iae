# frozen_string_literal: true

# This module will handle cross models visits.
# i.e. a guest cannot visit some developers views (such as sign-in) when logged-in
# as guest, and viceversa. They will be redirected to feed.
# This avoid a user logging-in twice as two different model (and messing with tokens).
module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_guest
      flash.clear
      redirect_to(posts_path) and return
    elsif current_developer
      flash.clear
      redirect_to(posts_path) and return
    end
  end
end
