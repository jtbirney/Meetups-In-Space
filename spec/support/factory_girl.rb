require 'factory_girl'

FactoryGirl.define do
  factory :user do
    provider "github"
    sequence(:uid) { |n| n }
    sequence(:username) { |n| "jarlax#{n}" }
    sequence(:email) { |n| "jarlax#{n}@launchacademy.com" }
    sequence(:avatar_url)  { |n| "https://avatars2.githubusercontent.com/u/174825?v=3&s=400#{n}" }
  end
end

FactoryGirl.define do
  factory :meetup do
    sequence(:name) { |n| "Star Wars Episode #{n}" }
    sequence(:details) { |n| "For the fans of Star Wars Episode #{n}" }
    sequence(:location) { |n| "Millenium Falcon #{n}" }
  end
end
