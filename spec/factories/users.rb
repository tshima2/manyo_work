FactoryBot.define do
  factory :user, class: User do
    name { 'fb_normal'}
    email { 'fb_normal@example.com' }
    password { 'fb_normal'}
    admin { false }
  end
  factory :user_admin, class: User do
    name { 'fb_admin'}
    email { 'fb_admin@example.com' }
    password { 'fb_admin'}
    admin { true }
  end 
end
