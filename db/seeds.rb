# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# insert 10 User
prefix=""
10.times do |n|
  prefix=n.to_s.rjust(2, '0')
  name="test"+prefix
  email=name+'@example.com'
  password=name
  User.create(name: name, email: email, password: password)
end


# insert 1000 Task
require "date"
s1=Date.parse("2021-4-1")
s2=Date.parse("2021-12-31")
kind=["memo", "todo", "note"]
priorities=[*(0..2)]
#prioritis: [nil, *(0..2)]
users=User.ids

(1..1000).each do |i|
  Task.create(name: "#{kind[rand(2)]}-#{i.to_s}",
              #description: Faker::JapaneseMedia::DragonBall.character,
              description: Gimei.city.kanji,
              deadline: Random.rand(s1..s2).to_s,
              priority: priorities.sample,
              status: rand(1..3),
              user_id: users.sample)
end

