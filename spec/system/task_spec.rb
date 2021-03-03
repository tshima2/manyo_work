require 'rails_helper'
require 'helpers/basic_auth_helper.rb'

RSpec.describe 'タスク管理機能', type: :system do

  describe '新規作成機能' do
    before do
      @label_index=I18n.t('tasks.label_index')
      @label_show=I18n.t('tasks.label_show')
      @label_name=I18n.t('tasks.label_name')
      @label_description=I18n.t('tasks.label_description')      
      @label_submit_new=I18n.t('tasks.label_submit_new')

      #BASIC認証を通過
      visit_with_http_auth tasks_path
    end
    
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do

        # 1. new_task_pathに遷移する（新規作成ページに遷移する）
        visit new_task_path

        # 2. 新規登録内容を入力する
        fill_in "new_task_name", with: "task-1"
        fill_in "new_task_description", with: "コンテント１"

        # 3. 「Create Task」というvalue（表記文字）のあるボタンをクリックする
        click_on "new_task_submit"

        # 4. clickで登録された情報が、タスク確認ページに表示されているかを確認する
        expect(page).to have_content "task-1"
        expect(page).to have_content "コンテント１"

        # 5. 「登録する」というvalue（表記文字）のあるボタンをクリックする
        click_on "confirm_task_submit"

        # 6. clickで登録された情報が、タスク詳細ページに表示されているかを確認する
        expect(page).to have_content "task-1"
        expect(page).to have_content "コンテント１"

      end
    end
  end

  describe '一覧表示機能' do
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        FactoryBot.create(:task, name: 'task-1', description: 'description-1')
        FactoryBot.create(:task, name: 'task-2', description: 'description-2')

        #新規画面で項目入力
        visit new_task_path
        expect(page).to have_content @label_new
        fill_in "new_task_name", with: 'task-3'
        fill_in "new_task_description", with: 'description-3'

        #登録ボタン押下
        click_on "new_task_submit"

        #遷移した確認画面で登録ボタン押下
        expect(page).to have_content @label_confirm
        click_on "confirm_task_submit"

        #遷移した一覧画面の表示項目を取得
        expect(page).to have_content @label_index
        task_list_name = all('.task_row_name')
        task_list_description = all('.task_row_description')

        #一番上の表示項目が作成日時のあたらしい'task-1'/'description-1'であるかをチェック
        #expect(task_list_name.count).to eq 3
        #expect(task_list_description.count).to eq 3
        expect(task_list_name[0].text).to eq 'task-3'
        expect(task_list_name[1].text).to eq 'task-2'
        expect(task_list_name[2].text).to eq 'task-1'
        expect(task_list_description[0].text).to eq 'description-3'
        expect(task_list_description[1].text).to eq 'description-2'
        expect(task_list_description[2].text).to eq 'description-1'                

      end
    end
    
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        #テストで使用するためのタスクを作成
        task = FactoryBot.create(:task)

        #タスク一覧ページに遷移
        visit tasks_path

        # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
        # have_contentされているか（含まれているか）ということをexpectする（確認・期待する）
        expect(page).to have_content task.name
        expect(page).to have_content task.description

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
