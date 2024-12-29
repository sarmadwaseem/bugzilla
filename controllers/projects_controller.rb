# frozen_string_literal: true

class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_action :set_project, only: %i[edit update destroy]

  def index
    @projects = @projects.accessible_by(current_ability).paginate(page: params[:page], per_page: 5)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.admin_id = current_admin.id
    if @project.save
      create_project_managers
      create_project_engineers
      flash[:notice] = 'Project successfully Created.'
      redirect_to projects_path
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
    @managers = @project.managers
    @engineers = @project.engineers
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to projects_path
    else
      render :edit
    end
  end

  def destroy
    @project.tickets.destroy_all
    if @project.destroy
      flash[:notice] = 'Project successfully deleted.'
    else
      flash[:alert] = 'Failed to delete the project.'
    end
    redirect_to projects_path
  end

  def assign_manager
    @project = Project.find(params[:id])
    @manager = Manager.find(params[:project][:manager_ids])

    if @project.managers.include?(@manager)
      flash[:alert] = 'Manager is already assigned to the project.'
    else
      @project.managers << @manager
      flash[:notice] = 'Manager assigned to the project successfully.'
    end

    redirect_to edit_project_path(@project)
  end

  def unassign_manager
    @project = Project.find(params[:id])
    @manager = Manager.find(params[:manager_id])

    if @project.managers.include?(@manager)
      @project.managers.delete(@manager)
      flash[:notice] = 'Manager unassigned from the project.'
    else
      flash[:alert] = 'Manager is not assigned to the project.'
    end

    redirect_to edit_project_path(@project) # Redirect back to the edit page
  end

  def assign_engineer
    @project = Project.find(params[:id])
    @engineer = Engineer.find(params[:project][:engineer_ids])

    if @project.engineers.include?(@engineer)
      flash[:alert] = 'Engineer is already assigned to the project.'
    else
      @project.engineers << @engineer
      ProjectMailer.engineer_added_to_project_email(@engineer, @project).deliver_now
      flash[:notice] = 'Engineer assigned to the project successfully.'
      redirect_to edit_project_path(@project)
    end
  end

  def unassign_engineer
    @project = Project.find(params[:id])
    @engineer = Engineer.find(params[:engineer_id])

    if @project.engineers.include?(@engineer)
      @project.engineers.delete(@engineer)
      flash[:notice] = 'Engineer unassigned from the project.'
    else
      flash[:alert] = 'Engineer is not assigned to the project.'
    end

    redirect_to edit_project_path(@project)
  end

  private

  def create_project_managers
    manager_ids = Array(params.dig(:project, :manager_ids, :id))
    manager_ids.each do |manager_id|
      project_manager = ProjectManager.new(project_id: @project.id, manager_id:)
      @manager = Manager.find(manager_id) # Retrieve the manager for this iteration
      ProjectMailer.manager_added_to_project_email(@manager, @project).deliver_now
      unless project_manager.save
        error_message = "Error creating ProjectManager: #{project_manager.errors.full_messages.join(', ')}"
        raise StandardError, error_message
      end
    end
  end

  def create_project_engineers
    engineer_ids = Array(params.dig(:project, :engineer_ids, :id))
    engineer_ids.each do |engineer_id|
      project_engineer = ProjectEngineer.new(project_id: @project.id, engineer_id:)
      @engineer = Engineer.find(engineer_id) # Retrieve the engineer for this iteration
      # Send an email notification to the engineer
      ProjectMailer.engineer_added_to_project_email(@engineer, @project).deliver_now
      unless project_engineer.save
        error_message = "Error creating ProjectEngineer: #{project_engineer.errors.full_messages.join(', ')}"
        raise StandardError, error_message
      end
    end
  end

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Project not found.'
    redirect_to projects_path
  end

  protected

  def project_params
    params.require(:project).permit(:name, :description, manager_ids: [], engineer_ids: [])
  end
end
