# frozen_string_literal: true

module Engineers
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_admin!

    def index
      @engineer = Engineer.all
    end

    # GET /resource/sign_up
    def new
      @engineer = Engineer.new
    end

    # POST /resource
    def create
      @engineer = Engineer.new(engineer_params)
      @engineer.admin_id = current_admin.id

      if @engineer.save
        render plain: 'Created Successfully'
      else
        render :new
      end
    end

    protected

    def engineer_params
      params.require(:engineer).permit(:name, :email, :password, :password_confirmation)
    end
  end
end
