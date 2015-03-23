FactoryGirl.define do
  factory :icims_connection, class: "Icims::Connection" do
    user

    trait :connected do
      customer_id 2187
      username "crashoverride"
      key "riscisgood"
    end
  end

  factory :jobvite_connection, class: "Jobvite::Connection" do
    user

    trait :connected do
      api_key "MY_API_KEY"
      secret "MY_API_SECRET_SHHH"
    end

    trait :disconnected do
      api_key nil
      secret nil
    end
  end

  factory :user do
    sequence(:namely_user_id) { |n| "NAMELY-USER-#{n}" }
    subdomain ENV.fetch("TEST_NAMELY_SUBDOMAIN")
    access_token ENV.fetch("TEST_NAMELY_ACCESS_TOKEN")
    sequence(:refresh_token) { |n| "refresh-token-#{n}" }
    access_token_expiry { 15.minutes.from_now }
  end
end
