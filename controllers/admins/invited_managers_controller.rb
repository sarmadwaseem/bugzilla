# frozen_string_literal: true

module Admins
  class InvitedManagersController < ApplicationController
    before_action :authenticate_admin!

    def destroy
      @manager = Manager.find(params[:id])

      if @manager.discard
        flash[:notice] = 'Invited manager successfully deleted.'
      else
        flash[:alert] = 'Failed to delete invited manager.'
      end

      redirect_to root_path
    end

    def update
      @manager = Manager.find(params[:id])
      if @manager.undiscard
        flash[:notice] = 'Invited manager successfully recovered.'
      else
        flash[:alert] = 'Failed to recover invited manager.'
      end

      redirect_to root_path
    end
  end
end
