require "rails_helper"

describe Icims::Authentication do
  describe "#update" do
    context "with valid information" do
      it "updates the connection from the response" do
        connection = stub_connection(success: true)
        form_attributes = valid_form_attributes
        form = Icims::Authentication.new(
          connection: connection,
        )

        result = form.update(form_attributes)

        expect(result).to eq(true)
        expect(connection).to have_received(:update!).with(
          customer_id: 1,
          key: "def",
          username: "bob"
        )
      end
    end

    context "with invalid fields" do
      it "adds validation messages" do
        connection = stub_connection(success: false)
        form = Icims::Authentication.new(
          connection: connection,
        )

        result = form.update({})

        expect(result).to eq(false)
        expect(connection).not_to have_received(:update!)
        expect(form.errors.full_messages).to match_array([
          "Customer can't be blank",
          "Key can't be blank",
          "Username can't be blank"
        ])
      end
    end
  end

  def valid_form_attributes
    { customer_id: 1, key: "def", username: "bob" }
  end

  def stub_connection(success: true)
    double(Icims::Connection).tap do |connection|
      allow(connection).to receive(:update!).and_return(success)
    end
  end
end
