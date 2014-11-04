FactoryGirl.define do
  factory :jobvite_connection do
    user
  end

  factory :user do
    sequence(:namely_user_id) { |n| "NAMELY-USER-#{n}" }
    subdomain "some-company"
    sequence(:access_token) { |n| "access-token-#{n}" }
    sequence(:refresh_token) { |n| "refresh-token-#{n}" }
  end
end
