require "rails_helper"

describe AuthenticationFactory do
  context ".create" do
    context "greenhouse_connection" do
      it "returns a connection form" do
        authentication = create_authentication("greenhouse")
        expect(authentication.class).to eq(Greenhouse::Authentication)
      end
    end

    context "icims_connection" do
      it "returns a connection form" do
        authentication = create_authentication("icims")
        expect(authentication.class).to eq(Icims::Authentication)
      end
    end

    context "jobvite_connection" do
      it "returns a connection form" do
        authentication = create_authentication("jobvite")
        expect(authentication.class).to eq(Jobvite::Authentication)
      end
    end

    context "net_suite_connection" do
      it "returns a connection form" do
        authentication = create_authentication("net_suite")
        expect(authentication.class).to eq(NetSuite::Authentication)
      end
    end

    context "unknown type" do
      it "raises an error" do
        connection = create("greenhouse_connection", :connected)
        expect do
          AuthenticationFactory.create(
            connection: connection,
            integration_id: "nonexistant_connection"
          )
        end.to raise_exception(KeyError)
      end
    end
  end

  def create_authentication(integration_id)
    AuthenticationFactory.create(
      connection: create(:"#{integration_id}_connection", :connected),
      integration_id: integration_id
    )
  end

  def allow_integration(id:)
    expect { create_authentication(id) }.not_to raise_exception
  end
end
