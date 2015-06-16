require "rails_helper"

describe NetSuite::ConnectionRequest do
  describe "#update" do
    context "with valid information" do
      it "updates the connection from the response" do
        client = stub_client(success: true, id: "abc", token: "def")
        request_attributes = valid_request_attributes
        connection = stub_connection
        request = NetSuite::ConnectionRequest.new(
          connection: connection,
          client: client
        )

        result = request.update(request_attributes)

        expect(result).to eq(true)
        expect(connection).to have_received(:update!).with(
          instance_id: "abc",
          authorization: "def"
        )
        expect(client).
          to have_received(:create_instance).with(request_attributes)
      end
    end

    context "with invalid fields" do
      it "adds validation messages" do
        client = stub_client(success: true)
        connection = stub_connection
        request = NetSuite::ConnectionRequest.new(
          connection: connection,
          client: client
        )

        result = request.update({})

        expect(result).to eq(false)
        expect(connection).not_to have_received(:update!)
        expect(client).not_to have_received(:create_instance)
        expect(request.errors.full_messages).to match_array([
          "Account can't be blank",
          "Email can't be blank",
          "Password can't be blank"
        ])
      end
    end

    context "when the server request fails" do
      it "adds validation errors from the server" do
        client = stub_client(success: false, message: "oops")
        connection = stub_connection
        request = NetSuite::ConnectionRequest.new(
          connection: connection,
          client: client
        )

        result = request.update(valid_request_attributes)

        expect(result).to eq(false)
        expect(connection).not_to have_received(:update!)
        expect(request.errors.full_messages).
          to eq(%w(oops))
      end
    end
  end

  def valid_request_attributes
    { account_id: "a", email: "b", password: "c" }
  end

  def stub_connection
    double(NetSuite::Connection).tap do |connection|
      allow(connection).to receive(:update!)
    end
  end

  def stub_client(response_attributes)
    double(NetSuite::Client).tap do |client|
      allow(client).
        to receive(:create_instance).
        and_return(stub_response(response_attributes))
    end
  end

  def stub_response(attributes)
    success = attributes.fetch(:success, true)
    attributes.except(:success).tap do |response|
      allow(response).to receive(:success?).and_return(success)
    end
  end
end
