# frozen_string_literal: true

# app/controllers/admins/invited_engineers_controller.rb
module Admins
  class InvitedEngineersController < ApplicationController
    before_action :authenticate_admin!

    def destroy
      @engineer = Engineer.find(params[:id])

      if @engineer.discard
        flash[:notice] = 'Invited engineer successfully deleted.'
      else
        flash[:alert] = 'Failed to delete invited engineer.'
      end
      redirect_to root_path
    end

    def update
      @engineer = Engineer.find(params[:id])
      if @engineer.undiscard
        flash[:notice] = 'Invited engineer successfully recovered.'
      else
        flash[:alert] = 'Failed to recover invited engineer.'
      end

      redirect_to root_path
    end
  end
end
