# frozen_string_literal: true

FactoryBot.define do
  factory :lab do
    body                 { 'body' }
    description          { 'description' }
    keywords             { 'key,words' }
    sequence(:analytics) { |i| "UA-123-#{i}" }
    sequence(:slug)      { |i| "lab-#{i}" }
    sequence(:title)     { |i| "Lab #{i}" }
    version              { '1.0.0' }

    factory :lab_published do
      published_at { Time.zone.local(1984, 10, 23) }
    end
  end
end
