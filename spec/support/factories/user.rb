FactoryGirl.define do
  factory :user do
    password              { 'password' }
    password_confirmation { 'password' }
    sequence(:email)      { |i| "wbotelhos#{i}@example.com" }
  end
end
