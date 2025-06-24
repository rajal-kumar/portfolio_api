FactoryBot.define do
  factory :project do
    title { "MyString" }
    description { "MyText" }
    status { "MyString" }
    technology_stack { "MyString" }
    repository_url { "MyString" }
    live_url { "MyString" }
    notes { "MyText" }
  end
end
