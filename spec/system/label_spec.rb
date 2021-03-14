require 'rails_helper'

RSpec.describe 'ラベル機能のテスト', type: :system do

  before do
    @label_tasks_index = I18n.t('tasks.label_index')
    @label_tasks_show = I18n.t('tasks.label_show')
    @label_tasks_edit = I18n.t('tasks.label_edit')
    @label_tasks_link_edit = I18n.t('tasks.label_link_edit')

    @label1=FactoryBot.create(:label, name: "label-1")
    @label2=FactoryBot.create(:label, name: "label-2")
    @label3=FactoryBot.create(:label, name: "label-3")
    @user=FactoryBot.create(:user)
  end

  describe 'ラベル機能のテスト' do
    before do
      #0. ログインする
      visit root_path
      sleep(0.5)

      fill_in "session_email", with: @user.email
      fill_in "session_password", with: @user.password
      fill_in "session_password_confirmation", with: @user.password

      click_on "new_session_submit"
      sleep(0.5)
    end

    context 'タスクを登録/編集するときに複数のラベルを登録/編集できること' do
      it 'タスクを作成/複数のラベル紐付けして登録/詳細画面にて確認' do
        # 1.新規作成ページに遷移する
        visit new_task_path
        sleep(0.5)

        # 2. 新規登録内容を入力する
        fill_in "new_task_name", with: "task-1"
        fill_in "new_task_description", with: "コンテント１"
        fill_in "new_task_deadline", with: "9999-12-31"

        check "label-1"
        check "label-2"
        #find("task[label_ids][]", text: 'label-1', match: :first).click
        #check "task[label_ids][1]"
        #check "task_label_ids_1"
        #check "#task_label_ids_1"
        #find(:css, "task[label_ids][]").click
        #find(:css, "#task_label_ids_1").click

        within '#new_task_priority' do
          select '中'
        end
        within '#new_task_status' do
          select '着手中'
        end

        # 3. 「Create Task」というvalue（表記文字）のあるボタンをクリックする
        click_on "new_task_submit"
        sleep(0.5)

        # 4. clickで登録された情報が、確認ページに表示されているかを確認する
        expect(page).to have_content "task-1"
        expect(page).to have_content "コンテント１"
        expect(page).to have_content 'label-1'
        expect(page).to have_content 'label-2'
        expect(page).to have_content "9999-12-31"
        expect(page).to have_content "中"
        expect(page).to have_content "着手中"

        # 5. 「登録する」というvalue（表記文字）のあるボタンをクリックする
        click_on "confirm_task_submit"
        sleep(0.5)

        # 6. clickで登録された情報が、タスク詳細ページに表示されているかを確認する
        expect(page).to have_content "task-1"
        expect(page).to have_content "コンテント１"
        Task.last.labels.pluck(:name).each do |s|
          expect(page).to have_content s
        end
        expect(page).to have_content "9999-12-31"
        expect(page).to have_content "中"
        expect(page).to have_content "着手中"
      end

      it 'タスクを編集/複数のラベル紐付けして更新/詳細画面にて確認' do

        #ラベル紐付き済みタスクを1件登録
        @task1=FactoryBot.create(:task_with_labelling, name: 'title-1')

        #タスク一覧画面に遷移
        visit tasks_path
        sleep(0.5)

        expect(page).to have_content @label_tasks_index
        task_list_name = all('.task_row_name')
        _name = task_list_name[0].text

        # リスト内「編集」ボタン押下
        first(:link, @label_tasks_link_edit).click
        sleep(0.5)

        # 選択したタスクの編集ページに遷移していることを確認
        expect(page).to have_content @label_tasks_edit
        expect(page).to have_field 'task[name]', with: _name

        # チェックボックスをすべてチェックしてから更新ボタン押下
        check "label-1"
        check "label-2"
        check "label-3"
        click_on "new_task_submit"
        sleep(0.5)

        # 詳細画面に遷移し選択したラベルの紐付きを確認
        expect(page).to have_content @label_tasks_show
        expect(page).to have_content _name
        expect(page).to have_content "label-1"
        expect(page).to have_content "label-2"
        expect(page).to have_content "label-3"

      end
    end

    context '一覧画面でラベルによる検索が出来ること' do
      it '一覧画面でラベルを選択絞り込み/期待される件数のレコードが画面に表示されていること' do

        # "label-1" 紐付き済みタスクを1件登録
        # "label-1/label-2" 紐付き済みタスクを1件登録
        # "label-2/label-3" 紐付き済みタスクを1件登録
        @task1=FactoryBot.create(:task, name: 'title-1', user_id: @user.id)
        @labelling11=FactoryBot.create(:labelling, label: @label1, task: @task1)

        @task2=FactoryBot.create(:task, name: 'title-2', user_id: @user.id)
        @labelling21=FactoryBot.create(:labelling, label: @label1, task: @task2)
        @labelling22=FactoryBot.create(:labelling, label: @label2, task: @task2)

        @task3=FactoryBot.create(:task, name: 'title-3', user_id: @user.id)
        @labelling31=FactoryBot.create(:labelling, label: @label2, task: @task3)
        @labelling32=FactoryBot.create(:labelling, label: @label3, task: @task3)        

        #タスク一覧画面に遷移
        visit tasks_path
        sleep(0.5)
        expect(page).to have_content @label_tasks_index

        #リストボックスから先頭のラベルを選んで絞り込みボタン押下
        within '#index_task_label' do
          select 'label-2'
        end
        click_on 'index_filter_submit'
        sleep(0.5)

        #期待されるタスクが表示されていることを確認
        task_list_name = all('.task_row_name')
        expect(task_list_name.count).to eq 2
        expect(task_list_name[0].text).to eq 'title-2'
        expect(task_list_name[1].text).to eq 'title-3'

      end
    end
  end
end
