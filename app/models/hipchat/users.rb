module Hipchat
  class Users
    attr_reader :token
    def initialize(token)
      @token = token
    end

    def email_list
      user_ids.map { |id| get_email(id) }
    end

    private

    def get_email(id)
      get_user(id)["email"]
    end

    def get_user(id)
      http = Net::HTTP.new("api.hipchat.com", 443)
      http.use_ssl = true
      response = http.get("/v2/user/#{ id }", {"Authorization" => "Bearer #{ token }"})
      JSON.parse(response.body)
    end

    def user_ids
      http = Net::HTTP.new("api.hipchat.com", 443)
      http.use_ssl = true
      response = http.get("/v2/user", {"Authorization" => "Bearer #{ token }"})
      content = JSON.parse(response.body)
      content["items"].map { |item| item["id"] }
    end
  end
end
