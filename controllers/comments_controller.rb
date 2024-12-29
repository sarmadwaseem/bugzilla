# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_current_ticket, only: %i[create destroy]
  skip_before_action :verify_authenticity_token

  def new
    @ticket = Ticket.find(params[:ticket_id])
    @comment = Comment.new
  end

  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.create(comment_params)

    if current_engineer
      @comment.engineer_id = current_engineer.id
    else
      current_manager
      @comment.manager_id = current_manager.id
    end

    flash[:notice] = @comment.errors.full_messages unless @comment.save
    redirect_to ticket_path(params[:ticket_id])
  end

  def edit
    @comment = Comment.find(params[:id])
    @ticket = Ticket.find(params[:ticket_id])
  end

  def update
    @comment = Comment.find(params[:id])
    @ticket = @comment.ticket

    if @comment.update(comment_params)
      flash[:notice] = 'Comment updated successfully.'
    else
      flash[:error] = @comment.errors.full_messages.join(', ')
    end

    redirect_to ticket_path(params[:ticket_id])
  end

  def destroy
    @comment = Comment.find(params[:id])
    Rails.logger.debug "Parameters received for deleting comment: #{params.inspect}"
    @comment.destroy
    flash[:notice] = 'Comment deleted successfully.'
    redirect_to ticket_path(@comment.ticket)
  end

  protected

  def comment_params
    params.require(:comment).permit(:description).merge(ticket_id: params[:ticket_id])
  end

  def set_current_ticket
    @current_ticket = Ticket.find_by(id: params[:ticket_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Ticket not found.'
    redirect_to tickets_path
  end
end
