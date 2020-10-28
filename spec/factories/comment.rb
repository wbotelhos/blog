FactoryBot.define do
  factory :comment do
    association      :commentable
    body             { 'body' }
    sequence(:email) { |i| "john#{i}@example.org" }
    sequence(:name)  { |i| "John #{i}" }
    url              { 'https://example.org' }

    factory :comment_answered do
      pending { false }
    end

    factory :comment_with_author do
      author { true }
      email  { 'author@example.org' }
    end
  end
end
