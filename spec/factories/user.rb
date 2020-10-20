FactoryBot.define do
  factory :user do
    password              { 'password' }
    password_confirmation { 'password' }
    sequence(:email)      { |i| "wbotelhos#{i}@example.com" }
    sequence(:name)       { |i| "User #{i}" }
  end
end
