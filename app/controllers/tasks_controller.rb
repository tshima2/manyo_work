class TasksController < ApplicationController

  before_action :do_auth, only:[:index, :new, :show, :edit, :destroy, :confirm]
  before_action :set_task, only:[:show, :edit, :update, :destroy]
  def index
    unless @current_user
      redirect_to new_sessions_path, notice: t('notice.login_needed')
    end

    # 絞り込み用ボタンが押された場合
    if params["filter"] && params["filter"]["name"].present?
      @filter_name = params["filter"]["name"]
    end
    if params["filter"] && params["filter"]["status"].present?
      @filter_status = params["filter"]["status"]
    end

    tasks=@current_user.tasks

    # フィルタリング("speghetti"条件分岐をなくす) + ソート（リンクが踏まれた場合）
    tasks = tasks.name_like(@filter_name).status_search(@filter_status).alter_sort_by(params)
    # tasks = tasks.name_like(@filter_name).status_search(@filter_status)
    # tasks = tasks.created_sort(params["sort_created"]).deadline_sort(params["sort_deadline"]).priority_sort(params["sort_priority"])

    # ページネーション
    @tasks=tasks.page(params[:page]).per(20)
  end

  def new
    unless @current_user
      redirect_to new_sessions_path, notice: t('notice.login_needed')
    else
      @task=Task.new
#      @labels=Label.all.order(id: :asc)
    end
  end

  def confirm
    byebug

    unless @current_user
      redirect_to new_sessions_path, notice: t('notice.login_needed')
    else
      @task = Task.new(task_params)
      render :new if @task.invalid?
    end
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

  def edit
#      @labels=Label.all.order(id: :asc)
  end

  def update
    if @task.update(task_params)
      redirect_to task_path, notice: t('tasks.msg_update_success')
    else
      render :edit
    end
  end

  def show
#      @labels=Label.all.order(id: :asc)
  end

  def destroy
    unless @current_user
      redirect_to new_sessions_path, notice: t('notice.login_needed')
    else
      @task.destroy
      redirect_to tasks_path, notice: t('tasks.msg_destroy_success')
    end
  end

  private
  def set_task
    @task=Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :deadline, :priority, :status, :user_id, label_ids: [])
  end

  def do_auth
    authenticate_user
  end
end
