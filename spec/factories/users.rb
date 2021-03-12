FactoryBot.define do
  factory :user, class: User do
    name { 'normal'}
    email { 'normal@example.com' }
    password { 'normal'}
    admin { false }
  end
  factory :user_admin, class: User do
    name { 'admin'}
    email { 'admin@example.com' }
    password { 'admin'}
    admin { true }
  end 
end
