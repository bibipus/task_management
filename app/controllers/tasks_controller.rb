class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    if params[:project_id].present?
      @project = current_user.projects.find(params[:project_id])
      tasks = @project.tasks
    else
      tasks = current_user.tasks
    end

    tasks = tasks.search_by_title(params[:q]) if params[:q].present?
    tasks = tasks.with_tags(params[:tag_ids]) if params[:tag_ids].present?
    case params[:filter]
    when 'done'
      tasks = tasks.where(is_done: true)
    when 'not_done'
      tasks = tasks.where(is_done: false)
    end
    tasks = tasks.order(created_at: :desc)
    @pagy, @tasks = pagy(tasks)
  end




  def show
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to @task, notice: t('flash.tasks.created')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.tasks.updated')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('flash.tasks.destroyed')
  end

  def toggle_done
    @task = current_user.tasks.find(params[:id])

    @task.update(is_done: !@task.is_done)
    redirect_to tasks_path, notice: "Stav úkolu byl změněn."
  end

  private

  def set_project
    if params[:project_id].present?
      @project = current_user.projects.find(params[:project_id])
    end
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :is_done, :project_id, :attachment, tag_ids: [])
  end
end