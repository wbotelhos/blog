FactoryBot.define do
  factory :article, aliases: [:commentable] do
    association      :user
    body             { 'The Article' }
    sequence(:title) { |i| "Title #{i}" }

    factory :article_published do
      published_at { Time.local(1984, 10, 23) }
    end
  end
end
