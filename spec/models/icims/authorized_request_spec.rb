require "rails_helper"

describe Icims::AuthorizedRequest do
  describe "#headers" do
    it "request has the necessary information" do
      expect(authorized_request.headers.keys).
        to match_array [
          "content-type",
          "host",
          "x-icims-content-sha256",
          "x-icims-date",
        ]
    end

    it "sends a header with a hash of its payload" do
      expect(authorized_request.headers["x-icims-content-sha256"]).
        to eq OpenSSL::Digest::SHA256.new(post_request.payload).hexdigest
    end

    it "sends a header with formatted date time of its request" do
      Timecop.freeze(Time.current) do
        expect(authorized_request.headers["x-icims-date"]).
          to eq Time.current.iso8601
      end
    end
  end

  describe "#canonical_request" do
    it "returns a string of several attributes on the request" do
      request = RestClient::Request.new(
        method: :get,
        url: "https://api.icims.com/or-ya-know?fields=stuff",
        headers: {},
      )

      expect(authorized_request(request).canonical_request).
        to eq canonical_request(request)
    end
  end

  describe "#string_to_sign" do
    it "returns a string to sign" do
      Timecop.freeze do
        signable_string = [
          "x-icims-v1-hmac-sha256",
          "#{Time.current.iso8601}",
          "#{OpenSSL::Digest::SHA256.new(
            authorized_request.canonical_request)
          }",
        ].join("\n")

        expect(authorized_request.string_to_sign).to eq signable_string
      end
    end
  end

  describe "#signature" do
    it "returns a signature" do
      signed_string = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest::SHA256.new,
        connection.key,
        authorized_request.string_to_sign,
      )

      expect(authorized_request.signature).to eq signed_string
    end
  end

  describe "#authorization_header" do
    it "returns the value for the 'Authorization' header" do
      header = [
        "x-icims-v1-hmac-sha256 user=#{connection.username}",
        "signedheaders=content-type;host;x-icims-content-sha256;x-icims-date",
        "signature=#{authorized_request.signature}",
      ].join(", ")

      expect(authorized_request.authorization_header).to eq header
    end
  end

  describe "#execute" do
    it "sends the request with the appropriate authorization header" do
      request = stub_request(
        :post,
        post_request.url,
      ).with(
        headers: {
          "Authorization" => authorized_request.authorization_header,
        }
      )

      authorized_request.execute

      expect(request).to have_been_requested
    end

    context "an authentication error is returned" do
      it "sends an invalid authentication message" do
        stub_request(
          :post,
          post_request.url,
        ).with(
          headers: {
            "Authorization" => authorized_request.authorization_header,
          }
        ).to_return(status: 401, body: errors.to_json)

        mail = double(ConnectionMailer, deliver: true)
        exception = Unauthorized.new("401 Unauthorized")
        user = connection.user
        allow(ConnectionMailer).
          to receive(:authentication_notification).
          with(
            connection_type: "icims",
            email: user.email,
            message: exception.message,
          ).
          and_return(mail)

        expect { authorized_request.execute }.to raise_error(
          Unauthorized
        )
        expect(mail).to have_received(:deliver)
      end
    end
  end

  def authorized_request(request = post_request)
    @authorized_request ||= described_class.new(
      connection: connection,
      request: request,
    )
  end

  def connection
    @connection ||= build(:icims_connection, :connected)
  end

  def errors
    {
      "errors" => [
        {
          "errorCode": 9,
          "errorMessage": "Authentication credentials invalid"
        }
      ]
    }
  end

  def post_request
    @request ||= RestClient::Request.new(
      method: :post,
      url: "https://api.icims.com/or-whatever",
      headers: {},
      data: {}.to_json,
    )
  end

  def canonical_request(request)
    <<-REQUEST.strip_heredoc.strip
      #{request.method.upcase}
      /or-ya-know
      fields=stuff
      content-type:application/json
      host:api.icims.com
      x-icims-content-sha256:#{authorized_request(request).headers["x-icims-content-sha256"]}
      x-icims-date:#{authorized_request(request).headers["x-icims-date"]}

      content-type;host;x-icims-content-sha256;x-icims-date
    REQUEST
  end
end
