# frozen_string_literal: true

class TicketsController < ApplicationController
  load_and_authorize_resource

  before_action :set_current_project, only: %i[index new create]

  def index
    @tickets = @current_project.tickets.accessible_by(current_ability)
  end

  def show
    @ticket = Ticket.find(params[:id])
    @project = @ticket.project
    @comment = Comment.new
  end

  def new
    @project_id = params[:project_id]
    @ticket = Ticket.new
  end

  def edit
    @project_id = params[:project_id]
    @ticket = Ticket.find(params[:id])
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update(ticket_params)
      flash[:notice] = 'Ticket updated successfully.'
      redirect_to ticket_path(@ticket)
    else
      Rails.logger.debug @ticket.errors.full_messages
      render :edit
    end
  end

  def create
    @ticket = current_manager.tickets.build(ticket_params)
    @ticket.manager_id = current_manager.id

    @ticket.project = @current_project if @current_project.present?

    if @ticket.save
      flash[:notice] = 'Created Successfully'

      # Retrieve the engineer associated with the ticket
      @engineer = @ticket.engineer

      # Check if an engineer is associated with the ticket before sending the email
      TicketMailer.engineer_added_to_ticket_email(@engineer, @ticket).deliver_now if @engineer.present?
      redirect_to project_tickets_path
    else
      Rails.logger.debug @ticket.errors.full_messages
      render :new
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    redirect_to tickets_path, notice: 'Ticket was successfully deleted.'
  end

  def update_status
    @ticket = Ticket.find(params[:id])
    new_status = params[:new_status] # This should be the new status value ("approved" or "rejected")
    if @ticket.update(status: new_status)
      flash[:notice] = 'Ticket status updated successfully.'
    else
      flash[:error] = 'Ticket to update patch status.'
    end
    redirect_to tickets_path(@ticket.project)
  end

  private

  def ticket_params
    params.require(:ticket).permit(:name, :description, :status, :severity, :priority, :date, :engineer_id)
  end

  def set_current_project
    @current_project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Project not found.'
    redirect_to projects_path
  end
end
