# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# insert 10 User, +1 admin User
prefix=""
10.times do |n|
  prefix=n.to_s.rjust(2, '0')
  name="test"+prefix
  email=name+'@example.com'
  password=name
  User.create(name: name, email: email, password: password)
end

# +1 admin User
  name="admin"
  email=name+'@example.com'
  password=name
  User.create(name: name, email: email, password: password, admin: true)

# insert 1000 Task
require "date"
from=Date.parse("2021-4-1")
to=Date.parse("2021-12-31")
kind=["memo", "todo", "note"]
priorities=[*(0..2)]
#prioritis: [nil, *(0..2)]
users=User.ids

(1..1000).each do |i|
  Task.create(name: "#{kind[rand(2)]}-#{i.to_s}",
              #description: Faker::JapaneseMedia::DragonBall.character,
              description: Gimei.city.kanji,
              deadline: Random.rand(from..to).to_s,
              priority: priorities.sample,
              status: rand(1..3),
              user_id: users.sample)
end

# insert 10 Label
labels=["技術調査","運用","開発","設計","言語","試験","性能","マネジメント", "人材", "レビュー"]
(1..10).each do |i|
  #  Label.create(name: Gimei.unique.prefecture.kanji)
  Label.create(name: labels.sample)
end

# insert 1000 Labelling
tasks=Task.ids
labels=Label.ids
(1..1000).each do |i|
  loop do
    id1=labels.sample; id2=tasks.sample
    unless Labelling.find_by(label_id: id1, task_id: id2)
      if Labelling.create(label_id: id1, task_id: id2) then break
      end
    end
  end

end

