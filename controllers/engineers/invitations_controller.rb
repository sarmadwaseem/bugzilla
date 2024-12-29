# frozen_string_literal: true

module Engineers
  class InvitationsController < Devise::InvitationsController
    prepend_before_action :authenticate_admin!, only: %i[new create]

    def index
      @engineers = Engineer.all
    end

    def invite_params
      params.require(:engineer).permit(:email, :name) # Add other attributes as needed
    end
  end
end
