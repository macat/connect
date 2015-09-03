require "rails_helper"

describe NetSuite::ApiError do
  describe "#message" do
    context "with a JSON message" do
      it "returns the encoded message" do
        message = "Error"
        error = NetSuite::ApiError.new({ "providerMessage" => message }.to_json)

        result = error.message

        expect(result).to eq(message)
      end
    end

    context "with a JSON provider message" do
      it "returns the encoded message" do
        message = "Error"
        error = NetSuite::ApiError.new({ "message" => message }.to_json)

        result = error.message

        expect(result).to eq(message)
      end
    end

    context "with JSON without a message" do
      it "returns a default message" do
        error = NetSuite::ApiError.new({}.to_json)

        result = error.message

        expect(result).to eq("Unknown error")
      end
    end

    context "with an empty response" do
      it "returns a default message" do
        error = NetSuite::ApiError.new(nil)

        result = error.message

        expect(result).to eq("Unknown error")
      end
    end
  end
end
