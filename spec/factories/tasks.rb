FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    name { 'タイトル１' }
    description { 'コンテント１' }
    deadline { '9999-12-31' }
    priority { 10 }
    status { 1 }
  end

end
