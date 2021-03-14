require 'rails_helper'

RSpec.describe Task, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"

  before do
    @user=FactoryBot.create(:user)
    @task=FactoryBot.create(:task, user_id: @user.id)
    FactoryBot.create(:task, name: 'TODO-1', status: 1, user_id: @user.id)
    FactoryBot.create(:task, name: 'TODO-2', status: 2, user_id: @user.id)
    FactoryBot.create(:task, name: 'MEMO-1', status: 3, user_id: @user.id)
    FactoryBot.create(:task, name: 'MEMO-2', status: 1, user_id: @user.id)
    FactoryBot.create(:task, name: 'MEMO-3', status: 2, user_id: @user.id)
  end

  describe 'タスクモデル機能', type: :model do
    describe 'バリデーションのテスト' do
      context 'タスクの名前が空の場合' do
        it 'バリデーションにひっかかる' do
          task= Task.new(name: '', description: '説明', user_id: @user.id)
          expect(task).not_to be_valid
        end
      end

      context 'タスクの名前が空でない場合' do
        it 'バリデーションに通る' do
          task= Task.new(name: '名前', description: '', user_id: @user.id)
          expect(task).to be_valid
        end
      end

      context 'タスクの名前が一意でない場合' do
        it 'バリデーションにひっかかる' do
          expect{
            Task.create!(name: @task.name)
          }.to raise_error(ActiveRecord::RecordInvalid)

        end
      end
    end

    describe 'scopeのテスト' do
      context 'scopeメソッドでタイトルのあいまい検索ができる' do
        it 'name_like' do
          Task.name_like('TODO').each do |rec|
            expect(rec.name.include?('TODO')).to eq true
          end
          Task.name_like('MEMO').each do |rec|
            expect(rec.name.include?('MEMO')).to eq true
          end
        end
      end

      context 'scopeメソッドでステータス検索ができる' do
        it 'status_search' do
          Task.status_search(1).each do |rec|
            expect(rec.status).to eq 1
          end
          Task.status_search(2).each do |rec|
            expect(rec.status).to eq 2
          end
          Task.status_search(3).each do |rec|
            expect(rec.status).to eq 3
          end
        end
      end

      context 'scopeメソッドでタイトルのあいまい検索、かつステータスの両方が検索できる' do
        it 'name_like and status_search' do
          Task.name_like('TODO').status_search(1).each do |rec|
            expect(rec.name.include?('TODO')).to eq true
            expect(rec.status).to eq 1
          end
        end
      end

      context 'scopeメソッドで指定されたラベルの貼られたタスクを検索できる' do
        it 'label_search' do
          la=FactoryBot.create(:label)
          lg=FactoryBot.create(:labelling, label: la, task: @task)

#          label_id, task_count = Labelling.group(:label_id).count(:task_id).first
          expect(Task.label_search(la.id).count).to eq 1
          expect(Task.label_search(la.id).first.id).to eq @task.id
        end
      end

    end
  end
end

