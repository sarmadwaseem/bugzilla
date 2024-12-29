# frozen_string_literal: true

class TicketMailer < ApplicationMailer
  def engineer_added_to_ticket_email(engineer, ticket)
    @engineer = engineer
    @ticket = ticket
    mail(to: @engineer.email, subject: 'A ticket is assigned to you.')
  end
end
