class TasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]
  def index
    if params[:sort] && params[:sort]=="1"
      @tasks=Task.all.order(created_at: 'DESC')
    else
      @tasks=Task.all.order(id: 'ASC')
    end
  end

  def new
    @task=Task.new
  end

  def confirm
    
    @task = Task.new(task_params)
    render :new if @task.invalid?
  end
  
  def create
    @task=Task.new(task_params)
    if params[:back]
      render :new
    elsif @task.save
      redirect_to tasks_path, notice: t('tasks.msg_create_success')
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_path, notice: t('tasks.msg_update_success')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('tasks.msg_destroy_succcess')
  end

  private
  def set_task
    @task=Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
