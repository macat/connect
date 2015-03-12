require "base64"

module Icims
  class Connection < ActiveRecord::Base
    belongs_to :user

    def connected?
      username.present? && password.present? && customer_id.present?
    end

    def api_url
      "https://api.icims.com/customers/#{customer_id}"
    end

    def key
      "Basic #{encoded_credentials}"
    end

    def disconnect
      update(
        password: nil,
        username: nil,
      )
    end

    private

    def encoded_credentials
      Base64.encode64("#{username}:#{password}")
    end
  end
end
