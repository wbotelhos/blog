FactoryGirl.define do

  factory :user do
    name "Washington Botelho"
    sequence(:email) { |i| "wbotelhos#{i}@gmail.com" }
    password "test"
    password_confirmation "test"
  end

  factory :category do
    name "name"
  end

  factory :article do
    title "title"
    body "body <!--more--> body"
    association :user
    categories { |categories| [categories.association(:category)] }
  end

  factory :article_category do
    association :article
    association :category
  end

  factory :comment do
    name "name"
    sequence(:email) { |i| "email#{i}@mail.com" }
    url "http://url.com"
    body "body"
    association :article
  end

  preload do
    factory(:user) do
      FactoryGirl.create(:user)
    end

    factory(:category) do
      FactoryGirl.create(:category)
    end

    factory(:article) do
      FactoryGirl.create(:article, {
        :user => users(:user)
      })
    end

    factory(:comment) do
      FactoryGirl.create(:comment, {
        :article => articles(:article)
      })
    end
  end

end
