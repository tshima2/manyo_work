require 'rails_helper'
require 'helpers/basic_auth_helper.rb'

RSpec.describe 'タスク管理機能', type: :system do

  before do
    @label_index=I18n.t('tasks.label_index')
    @label_show=I18n.t('tasks.label_show')
    @label_name=I18n.t('tasks.label_name')
    @label_description=I18n.t('tasks.label_description')
    @label_submit_new=I18n.t('tasks.label_submit_new')
    @label_link_sort_created=I18n.t('tasks.label_link_sort_created')
    @label_link_sort_expired=I18n.t('tasks.label_link_sort_expired')    

      #BASIC認証を通過
      visit_with_http_auth tasks_path
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示され、ステータスも登録ができる' do

        # 1. new_task_pathに遷移する（新規作成ページに遷移する）
        visit new_task_path

        # 2. 新規登録内容を入力する
        fill_in "new_task_name", with: "task-1"
        fill_in "new_task_description", with: "コンテント１"
        fill_in "new_task_deadline", with: "9999-12-31"
        fill_in "new_task_priority", with: "10"
        within '#new_task_status' do
          select '着手中'
        end

        # 3. 「Create Task」というvalue（表記文字）のあるボタンをクリックする
        click_on "new_task_submit"

        # 4. clickで登録された情報が、確認ページに表示されているかを確認する
        expect(page).to have_content "task-1"
        expect(page).to have_content "コンテント１"
        expect(page).to have_content "9999-12-31"
        expect(page).to have_content "10"
        expect(page).to have_content "着手中"

        # 5. 「登録する」というvalue（表記文字）のあるボタンをクリックする
        click_on "confirm_task_submit"

        # 6. clickで登録された情報が、タスク詳細ページに表示されているかを確認する
        expect(page).to have_content "task-1"
        expect(page).to have_content "コンテント１"
        expect(page).to have_content "9999-12-31"
        expect(page).to have_content "10"
        expect(page).to have_content "着手中"

      end
    end
  end

  describe '一覧表示機能' do
    context '（作成時刻でソート）リンクをクリックされた場合' do
      it '新しいタスクが一番上に表示される' do
        FactoryBot.create(:task, name: 'task-1', description: 'description-1')
        FactoryBot.create(:task, name: 'task-2', description: 'description-2')
        FactoryBot.create(:task, name: 'task-3', description: 'description-3')

        #遷移した一覧画面の表示項目を取得
        visit tasks_path

        click_link @label_link_sort_created
        sleep(3)

        #task_list_name = all('.task_row_name')
        task_list_name = all('.task_row_name', wait: 50)

        # trying to avoid Capybara::ElementNotFound Error..
        # sleep(5) by ruby

        #一番上の表示項目が作成日時のあたらしい'task-3'/'description-3'であるかをチェック
        expect(task_list_name[0].text).to eq 'task-3'
        expect(task_list_name[1].text).to eq 'task-2'
        expect(task_list_name[2].text).to eq 'task-1'
      end
    end
    context '（終了期限でソート）リンクをクリックされた場合' do
      it '終了期限の近いタスクを先頭に、昇順に表示される' do
        FactoryBot.create(:task, name: 'task-1', deadline: '2021-9-31')
        FactoryBot.create(:task, name: 'task-2', deadline: '2021-3-30')
        FactoryBot.create(:task, name: 'task-3', deadline: '2021-6-30')

        #遷移した一覧画面の表示項目を取得
        visit tasks_path
        click_link @label_link_sort_expired
        sleep(3)

        #task_list_name = all('.task_row_name')
        task_list_name = all('.task_row_name', wait: 50)

        #終了期限の近いタスクを先頭に、昇順に表示される
        expect(task_list_name[0].text).to eq 'task-2'
        expect(task_list_name[1].text).to eq 'task-3'
        expect(task_list_name[2].text).to eq 'task-1'

      end
    end

    context '検索をした場合' do
      it 'タイトルで検索できる' do

        FactoryBot.create(:task, name: 'TODO-1', status: 1)
        FactoryBot.create(:task, name: 'TODO-2', status: 2)
        FactoryBot.create(:task, name: 'MEMO-3', status: 3)
        FactoryBot.create(:task, name: 'MEMO-4', status: 1)

        visit tasks_path
        fill_in "index_task_name", with: 'TODO'
        click_on 'index_filter_submit'
        sleep(3)

        task_list_name = all('.task_row_name')
        expect(task_list_name.count).to eq 2
        expect(task_list_name[0].text).to eq 'TODO-1'
        expect(task_list_name[1].text).to eq 'TODO-2'

      end

      it 'ステータスで検索できる' do

        FactoryBot.create(:task, name: 'TODO-1', status: 1)
        FactoryBot.create(:task, name: 'TODO-2', status: 2)
        FactoryBot.create(:task, name: 'MEMO-3', status: 3)
        FactoryBot.create(:task, name: 'MEMO-4', status: 1)

        visit tasks_path
        within '#index_task_status' do
          select '未着手'
        end
        click_on 'index_filter_submit'
        sleep(3)

        task_list_name = all('.task_row_name', wait: 50)
        expect(task_list_name.count).to eq 2
        expect(task_list_name[0].text).to eq 'TODO-1'
        expect(task_list_name[1].text).to eq 'MEMO-4'

      end

      it 'タイトルとステータスの両方で検索できる' do

        FactoryBot.create(:task, name: 'TODO-1', status: 1)
        FactoryBot.create(:task, name: 'TODO-2', status: 2)
        FactoryBot.create(:task, name: 'MEMO-3', status: 3)
        FactoryBot.create(:task, name: 'MEMO-4', status: 1)

        visit tasks_path
        fill_in 'index_task_name', with: 'TODO'
        within '#index_task_status' do
          select '未着手'
        end
        click_on 'index_filter_submit'
        sleep(3)

        task_list_name = all('.task_row_name', wait: 50)
        expect(task_list_name.count).to eq 1
        expect(task_list_name[0].text).to eq 'TODO-1'

      end

    end

  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        #テストで使用するためのタスクを作成
        task = FactoryBot.create(:task)

        #タスク詳細ページに遷移
        visit task_path(task.id)

        expect(page).to have_content @label_show
        expect(page).to have_content task.name
        expect(page).to have_content task.description

      end
     end
  end
end
