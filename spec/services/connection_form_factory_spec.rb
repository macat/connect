require "rails_helper"

describe ConnectionFormFactory do
  context ".create" do
    context "greenhouse_connection" do
      it "returns a connection form" do
        connection_form = create_connection_form("greenhouse")
        expect(connection_form.class).to eq(Greenhouse::ConnectionForm)
      end
    end

    context "icims_connection" do
      it "returns a connection form" do
        connection_form = create_connection_form("icims")
        expect(connection_form.class).to eq(Icims::ConnectionForm)
      end
    end

    context "jobvite_connection" do
      it "returns a connection form" do
        connection_form = create_connection_form("jobvite")
        expect(connection_form.class).to eq(Jobvite::ConnectionForm)
      end
    end

    context "net_suite_connection" do
      it "returns a connection form" do
        connection_form = create_connection_form("net_suite")
        expect(connection_form.class).to eq(NetSuite::ConnectionForm)
      end
    end

    context "unknown type" do
      it "raises an error" do
        connection = create("greenhouse_connection", :connected)
        expect do
          ConnectionFormFactory.create(
            connection: connection,
            integration_id: "nonexistant_connection"
          )
        end.to raise_exception(KeyError)
      end
    end
  end

  def create_connection_form(integration_id)
    ConnectionFormFactory.create(
      connection: create(:"#{integration_id}_connection", :connected),
      integration_id: integration_id
    )
  end

  def allow_integration(id:)
    expect { create_connection_form(id) }.not_to raise_exception
  end
end
