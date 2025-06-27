FactoryBot.define do
  factory :project do
    title { "My Project" }
    description { "Something useful" }
    status { "in_progress" }
    technology_stack { "Rails" }
    repository_url { "https://github.com/my_project" }
    live_url { "https://myproject.live" }
    notes { "Some notes" }
  end
end
