require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do

        # 1. new_task_pathに遷移する（新規作成ページに遷移する）
        visit new_task_path

        # 2. 新規登録内容を入力する
        fill_in 'Name', with: "task-1"
        fill_in 'Description', with: "コンテント１"

        # 3. 「Create Task」というvalue（表記文字）のあるボタンをクリックする
        click_on 'Create Task'

        # 4. clickで登録された情報が、タスク確認ページに表示されているかを確認する
        expect(page).to have_content "task-1"
        expect(page).to have_content "コンテント１"

        # 5. 「登録する」というvalue（表記文字）のあるボタンをクリックする
        click_on '登録する'

        # 6. clickで登録された情報が、タスク詳細ページに表示されているかを確認する
        expect(page).to have_content "task-1"
        expect(page).to have_content "コンテント１"

      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        #テストで使用するためのタスクを作成
        task = FactoryBot.create(:task, name: 'task-2')

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
        task = FactoryBot.create(:task, name: 'task-3')

        #タスク詳細ページに遷移
        visit task_path(task.id)

        expect(page).to have_content '詳細画面'
        expect(page).to have_content task.name
        expect(page).to have_content task.description
        # expectの結果が true ならテスト成功、false なら失敗として結果が出力される

      end
     end
  end
end
