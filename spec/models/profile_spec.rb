require "rails_helper"

describe Profile do
  describe "delegations" do
    subject { Profile.new(stub_profile_data) }
    it { should delegate_method(:[]).to(:namely_profile) }
    it { should delegate_method(:update).to(:namely_profile) }
  end

  describe "#name" do
    it "returns #first_name #last_name" do
      profile_data = stub_profile_data.merge(
        first_name: "First",
        last_name: "Last"
      )
      profile = Profile.new(profile_data)

      expect(profile.name).to eq("First Last")
    end
  end

  def stub_profile_data
    {
      email: "test@example.com",
      first_name: "First",
      last_name: "Last",
    }.merge(stub_job_title)
  end

  def stub_job_title(title = "Developer")
    {
      job_title: {
        "id" => "1234",
        "title" => title
      }
    }
  end
end
