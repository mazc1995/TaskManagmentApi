FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    full_name { Faker::Name.name }
    role { :user }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
