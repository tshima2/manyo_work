class TasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]

  def index
    
    # 絞り込み用ボタンが押された場合
    if params["filter"] && params["filter"]["name"].present?
      @filter_name = params["filter"]["name"]
    end
    if params["filter"] && params["filter"]["status"].present?
      @filter_status = params["filter"]["status"]
    end

    #(スパゲティ)条件分岐
    if @filter_name
      if @filter_status
        #@tasks=Task.where('name LIKE ?', "%#{@filter_name}%").or(Task.where(status: @filter_status)).order(id: 'ASC')
        @tasks=Task.where('name LIKE ?', "%#{@filter_name}%").where(status: @filter_status).order(id: 'ASC')        
      else
        @tasks=Task.where('name LIKE ?', "%#{@filter_name}%").order(id: 'ASC')
      end

    else
      if @filter_status
        @tasks=Task.where('status = ?', @filter_status).order(id: 'ASC')
      else
        # ソート用リンクが踏まれた場合
        if params[:sort_created] && params[:sort_created]=="true"     # 作成日時の降順でソート
          @tasks=Task.all.order(created_at: 'DESC')
        elsif params[:sort_expired] && params[:sort_expired]=="true"  # 終了期限の昇り順でソート
          @tasks=Task.all.order(deadline: 'ASC')
        else
          @tasks=Task.all.order(id: 'ASC')                            # ソート順指定なし/idの昇順でソート
        end
      end

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
    redirect_to tasks_path, notice: t('tasks.msg_destroy_success')
  end

  private
  def set_task
    @task=Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :deadline, :priority, :status)
  end
end
