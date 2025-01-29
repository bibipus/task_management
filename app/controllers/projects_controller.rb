# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[edit update destroy]

  def index
    @pagy, @projects = pagy(
      current_user.projects
                  .includes(:tasks)
                  .search_by_title(params[:q])
                  .order(:position)
    )
  end

  def new
    @project = current_user.projects.new
  end

  def edit
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to projects_path, notice: t('flash.projects.created')
    else
      render :new, status: :unprocessable_entity, alert: t('flash.projects.created')
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: t('flash.projects.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: t('flash.projects.destroyed')
  end

  def sort
    Rails.logger.debug "Order param: #{params[:order].inspect}"
    Project.update_positions(params[:order])
    render json: { success: true }
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :position)
  end
end
