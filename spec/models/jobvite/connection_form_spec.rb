require "rails_helper"

describe Jobvite::ConnectionForm do
  describe "#update" do
    context "with valid information" do
      it "updates the connection from the response" do
        connection = stub_connection(success: true)
        form_attributes = valid_form_attributes
        form = Jobvite::ConnectionForm.new(
          connection: connection,
        )

        result = form.update(form_attributes)

        expect(result).to eq(true)
        expect(connection).to have_received(:update!).with(
          api_key: "def",
          secret: "bob"
        )
      end
    end

    context "with invalid fields" do
      it "adds validation messages" do
        connection = stub_connection(success: false)
        form = Jobvite::ConnectionForm.new(
          connection: connection,
        )

        result = form.update({})

        expect(result).to eq(false)
        expect(connection).not_to have_received(:update!)
        expect(form.errors.full_messages).to match_array([
          "Api key can't be blank",
          "Secret can't be blank"
        ])
      end
    end
  end

  def valid_form_attributes
    { api_key: "def", secret: "bob" }
  end

  def stub_connection(success: true)
    double(Jobvite::Connection).tap do |connection|
      allow(connection).to receive(:update!).and_return(success)
    end
  end
end
