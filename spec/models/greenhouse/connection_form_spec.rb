require "rails_helper"

describe Greenhouse::ConnectionForm do
  describe "#new" do
    it "populates secret_key from GreenhouseConnection#secure_key" do
      connection = create(:greenhouse_connection)
      form = Greenhouse::ConnectionForm.new(connection: connection)

      expect(form.secret_key).to eq(connection.secret_key)
      expect(form.secret_key).not_to be_empty
    end
  end

  describe "#update" do
    context "with valid information" do
      it "updates the connection from the response" do
        connection = stub_connection(success: true)
        form_attributes = valid_form_attributes
        form = Greenhouse::ConnectionForm.new(
          connection: connection,
        )

        result = form.update(form_attributes)

        expect(result).to eq(true)
        expect(connection).to have_received(:update!).with(
          name: "def",
          secret_key: "bob"
        )
      end
    end

    context "with invalid fields" do
      it "adds validation messages" do
        connection = stub_connection(success: false)
        form = Greenhouse::ConnectionForm.new(
          connection: connection,
        )

        result = form.update({})

        expect(result).to eq(false)
        expect(connection).not_to have_received(:update!)
        expect(form.errors.full_messages).to match_array([
          "Name can't be blank",
        ])
      end
    end
  end

  def valid_form_attributes
    { name: "def", secret_key: "bob" }
  end

  def stub_connection(success: true)
    double(Greenhouse::Connection).tap do |connection|
      allow(connection).to receive(:secret_key).and_return("SECRET_KEY")
      allow(connection).to receive(:update!).and_return(success)
    end
  end
end
