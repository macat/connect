module Hipchat
  class Users
    attr_reader :token
    def initialize(token)
      @token = token
    end

    def email_list
      user_ids.map { |id| get_email(id) }
    end

    def create_user(name:, email:)
      payload = JSON.dump({name: name, email: email})
      response = http.post("/v2/user", payload, {"Authorization" => "Bearer #{ token }"})
      JSON.parse(response.body)["id"]
    end

    private

    def get_email(id)
      get_user(id)["email"]
    end

    def get_user(id)
      response = http.get("/v2/user/#{ id }", {"Authorization" => "Bearer #{ token }"})
      JSON.parse(response.body)
    end

    def user_ids
      response = http.get("/v2/user", {"Authorization" => "Bearer #{ token }"})
      content = JSON.parse(response.body)
      content["items"].map { |item| item["id"] }
    end

    def http
      http = Net::HTTP.new("api.hipchat.com", 443)
      http.use_ssl = true
      http
    end
  end
end
