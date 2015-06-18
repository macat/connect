require "rails_helper"

describe ConnectionFormFactory do
  context ".create" do
    context "greenhouse_connection" do
      it "returns a connection form" do
        connection_form = create_connection_form("greenhouse_connection")
        expect(connection_form.class).to eq(Greenhouse::ConnectionForm)
      end
    end

    context "icims_connection" do
      it "returns a connection form" do
        connection_form = create_connection_form("icims_connection")
        expect(connection_form.class).to eq(Icims::ConnectionForm)
      end
    end

    context "jobvite_connection" do
      it "returns a connection form" do
        connection_form = create_connection_form("jobvite_connection")
        expect(connection_form.class).to eq(Jobvite::ConnectionForm)
      end
    end

    context "net_suite_connection" do
      it "returns a connection form" do
        connection_form = create_connection_form("net_suite_connection")
        expect(connection_form.class).to eq(NetSuite::ConnectionForm)
      end
    end

    context "unknown type" do
      it "raises an error" do
        connection = create("greenhouse_connection", :connected)
        expect do
          ConnectionFormFactory.create(
            connection: connection,
            form_type: "nonexistant_connection"
          )
        end.to raise_exception(KeyError)
      end
    end
  end

  def create_connection_form(form_type)
    ConnectionFormFactory.create(
      connection: create(form_type.to_sym, :connected),
      form_type: form_type
    )
  end

  def allow_form_type(form_type)
    expect { create_connection_form(form_type) }.not_to raise_exception
  end
end
