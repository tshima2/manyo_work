require "active_support/concern"

module SearchService
  extend AvtiveSupport::Concern

  class_methods do
    def do_filter(_tasks, name: _name=nil, status: _status=nil)
      if _name
        if _status
          _tasks.name_like(_name).status_search(_status)
        else
          _tasks.name_like(_name)
        end
      elsif _status
        _tasks.status_search(_status)
      end
    end

    def do_sort(_tasks, _sort_params)
      if _sort_params[:sort_created].present?      # 作成日時の降順でソート
        _tasks.created_sort
      elsif _sort_params[:sort_expired].present?   # 終了期限の昇順でソート
        _tasks.deadline_sort
      elsif _sort_params[:sort_priority].present?  # 優先順位の降順でソート
        _tasks.priority_sort
      else                                   # ソート順指定なし/idの昇順でソート
        _tasks.id_sort
      end
    end

  end
end
