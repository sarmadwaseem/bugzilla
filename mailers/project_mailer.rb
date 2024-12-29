# frozen_string_literal: true

class ProjectMailer < ApplicationMailer
  def engineer_added_to_project_email(engineer, project)
    @engineer = engineer
    @project = project
    mail(to: @engineer.email, subject: 'You have been added to a project')
  end

  def updated_project_email(engineer, project)
    @engineer = engineer
    @project = project
    mail(to: @engineer.email, subject: 'You have been added to a project')
  end

  def manager_added_to_project_email(manager, project)
    @manager = manager
    @project = project
    mail(to: @manager.email, subject: 'You have been added to a project')
  end
end
