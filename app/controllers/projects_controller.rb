class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = current_user.projects.order(:position)
  end

  def show
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to @project, notice: t('flash.projects.created')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: t('flash.projects.updated')
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: t('flash.projects.destroyed')
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :position)
  end
end