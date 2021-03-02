require 'rails_helper'

RSpec.describe Task, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"

  before do
    @fbtask=FactoryBot.create(:task)
  end

  describe 'タスクモデル機能', type: :model do
    describe 'バリデーションのテスト' do
      context 'タスクの名前が空の場合' do
        it 'バリデーションにひっかかる' do
          task= Task.new(name: '', description: '説明')
          expect(task).not_to be_valid
        end
      end

      context 'タスクの名前が空でない場合' do
        it 'バリデーションに通る' do
          task= Task.new(name: '名前', description: '')
          expect(task).to be_valid
        end
      end

      context 'タスクの名前が一意でない場合' do
        it 'バリデーションにひっかかる' do
          #task=Task.create(name: @fbtask.name)
          #expect(task).to eq nil

          expect{
            Task.create!(name: @fbtask.name)
          }.to raise_error(ActiveRecord::RecordInvalid)

        end
      end
    end
  end
end
    
