class Api::TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    pagy, tasks = pagy(task_service.list_tasks, page: params[:page])
    render json: {
      tasks: tasks,
      pagination: {
        page: pagy.page,
        items: pagy.items,
        count: pagy.count,
        pages: pagy.pages
      }
    }, status: :ok
  end

  def show
    render json: @task, status: :ok
  end

  def create
    @task = task_service.create_task(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    @task = task_service.update_task(@task.id, task_params)
    if @task.errors.empty?
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    task_service.delete_task(@task.id)
    head :no_content
  end

  private

  def set_task
    @task = task_service.find_task(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :user_id)
  end

  def task_service
    @task_service ||= TaskService.new
  end
end
