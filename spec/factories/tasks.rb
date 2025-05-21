FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    status { "MyString" }
    due_date { "2025-05-20" }
    user { nil }
  end
end
