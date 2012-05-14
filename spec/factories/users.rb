FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    sequence(:username) { |n| "username#{n}" }
    password "foobar"
    password_confirmation "foobar"
    factory :admin do
      roles ['admin']
    end
  end
end