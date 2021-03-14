FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）

  factory :task do
    name { 'タイトル１' }
    description { 'コンテント１' }
    deadline { '9999-12-31' }
    priority { 0 }
    status { 1 }
    user_id { User.ids.sample }
  end

  factory :task_with_labelling, class: Task do
    name { 'title-' }
    description { 'content-*' }
#    association :user_id, factory: :user
    user_id { User.ids.sample }

    after(:create) do |task|
      task.labellings << create(:labelling, label_id: Label.ids.sample, task_id: task.id)
    end
  end

end
