# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    case resource
    when Admin
      '/dashboard'
    when Manager
      if resource.projects.any?
        "/managers/#{resource.id}/assigned_projects_manager"
      else
        flash[:notice] = 'No projects assigned yet.'
        root_path
      end
    when Engineer
      if resource.projects.any?
        "/engineers/#{resource.id}/assigned_projects_engineer"
      else
        flash[:notice] = 'No projects assigned yet.'
        root_path
      end
    else
      super
    end
  end

  protected

  def authenticate_inviter!
    authenticate_admin!(force: true)
  end

  def current_user
    if admin_signed_in?
      current_admin
    elsif manager_signed_in?
      current_manager
    elsif engineer_signed_in?
      current_engineer
    else
      super
    end
  end
end
