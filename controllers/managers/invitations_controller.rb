# frozen_string_literal: true

module Managers
  class InvitationsController < Devise::InvitationsController
    prepend_before_action :authenticate_admin!, only: %i[new create]

    def index
      @managers = Manager.all
    end

    def invite_params
      params.require(:manager).permit(:email, :name) # Add other attributes as needed
    end
  end
end
