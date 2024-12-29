# frozen_string_literal: true

module Managers
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_admin!

    # GET /resource/sign_up
    def new
      @manager = Manager.new
    end

    # POST /resource
    def create
      @manager = Manager.new(manager_params)
      @manager.admin_id = current_admin.id

      if @manager.save
        render plain: 'Created Successfully'
      else
        render :new
      end
    end

    protected

    def manager_params
      params.require(:manager).permit(:name, :email, :password, :password_confirmation)
    end

    def after_sign_up_path_for(resource)
      assigned_projects_manager_path(resource)
    end
  end
end
