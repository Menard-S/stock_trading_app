FactoryBot.define do
  factory :user do
      email { "user@example.com" }
      name { "Test User" }
      yob { 1990 }
      asset { 0 }
      password { "password123" }
      role { 1 } # Admin role

      trait :trader do
          role { 0 } # Trader role
      end
  end
end
