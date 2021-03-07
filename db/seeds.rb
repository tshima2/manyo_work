# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "date"
s1=Date.parse("2021-4-1")
s2=Date.parse("2021-12-31")

kind=["memo", "todo", "note"]

(1..150).each do |i|
  Task.create(name: "#{kind[rand(2)]}-#{i.to_s}",
              #description: Faker::JapaneseMedia::DragonBall.character,
              description: Gimei.city.kanji,
              deadline: Random.rand(s1..s2).to_s,
#              priority: [nil, *(0..2)].sample,
              priority: [*(0..2)].sample,
              status: rand(1..3))
end

