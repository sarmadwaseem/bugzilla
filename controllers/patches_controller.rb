# frozen_string_literal: true

class PatchesController < ApplicationController
  load_and_authorize_resource
  before_action :set_current_ticket, only: %i[new create index]

  def index
    authorize! :index, Patch
    @patches = @current_ticket.patches.accessible_by(current_ability).with_attached_patch_file if @current_ticket
  end

  def assigned_patches_to_manager
    Rails.logger.debug "Params: #{params.inspect}"
    @ticket = Ticket.find(params[:id]) # Use params[:id] here
    @patches = @ticket.patches
  end

  def new
    @patch = Patch.new
  end

  def create
    # Build a new Patch object associated with the current engineer
    @patch = current_engineer.patches.build(patch_params)

    # Set the engineer_id attribute of the patch to the current engineer's ID
    @patch.engineer_id = current_engineer.id

    # Associate the ticket with the patch if a current ticket is present
    @patch.ticket = @current_ticket if @current_ticket.present?

    # Attempt to save the patch object to the database
    if @patch.save
      # Attach the patch file if it was uploaded
      attach_patch_file if params[:patch][:patch_file].present?

      # Set a success message to display to the user
      flash[:notice] = 'Patch created successfully.'

      # Redirect the user to the root path
      redirect_to ticket_patches_path
    else
      # If saving the patch failed, log the errors and re-render the 'new' view
      Rails.logger.debug @patch.errors.full_messages
      render :new
    end
  end

  def destroy
    @patch = Patch.find(params[:id])
    @patch.destroy
    flash[:notice] = 'Patch was successfully deleted.'
    redirect_to patches_path
  end

  def update_status
    @patch = Patch.find(params[:id])
    new_status = params[:new_status] # This should be the new status value ("approved" or "rejected")
    if @patch.update(status: new_status)
      flash[:notice] = 'Patch status updated successfully.'
      @engineer = @patch.engineer
      PatchMailer.reviewd_by_manager(@engineer, @patch).deliver_now if @engineer.present?
    else
      flash[:error] = 'Failed to update patch status.'
    end
    redirect_to patches_path
  end

  private

  def patch_params
    params.require(:patch).permit(:name, :comment, :date, :status)
  end

  def attach_patch_file
    @patch.patch_file.attach(params[:patch][:patch_file])
  end

  def set_current_ticket
    @current_ticket = Ticket.find_by(id: params[:ticket_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Ticket not found.'
    redirect_to tickets_path
  end
end
