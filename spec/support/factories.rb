FactoryGirl.define do

  factory :user do
    name                  "Washington Botelho"
    sequence(:email)      { |i| "wbotelhos#{i}@gmail.com" }
    password              "test"
    password_confirmation "test"
  end

  factory :category do
    name "name"
  end

  factory :article do
    sequence(:title)  { |i| "title #{i}" }
    sequence(:slug)   { |i| "title-#{i}" }
    body              "body <!--more--> body"
    association       :user
    categories        { |categories| [categories.association(:category)] }
  end

  factory :article_category do
    association :article
    association :category
  end

  factory :comment do
    sequence(:name)     { |i| "name-#{i}" }
    sequence(:email)    { |i| "email#{i}@mail.com" }
    url                 "http://url.com"
    body                "body"
    association         :article
  end

end
