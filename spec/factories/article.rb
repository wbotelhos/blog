# frozen_string_literal: true

FactoryBot.define do
  factory :article, aliases: [:commentable] do
    association      :user
    body             { 'The Article' }
    sequence(:title) { |i| "Title #{i}" }
    sequence(:slug)  { |i| "title-#{i}" }
  end

  trait :published do
    published_at { Time.zone.local(1984, 10, 23) }
  end
end
