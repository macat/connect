require "rails_helper"

describe CandidateImportMailer do
  describe "#successful_import" do
    subject { stub_successful_mailer }

    it "provides the integration name in the subject" do
      expect(subject.subject).to include(t("#{stub_integration_id}.name"))
    end

    it "provides the candidate name in the subject" do
      expect(subject.subject).to include(stub_candidate.name)
    end

    it "addresses the email" do
      expect(subject.to).to match_array([stub_email])
    end

    it "includes the candidate name and integration in the body" do
      expect(subject.body.to_s).to include(
        t(
          "candidate_import_mailer.successful_import.message",
          candidate_name: stub_candidate.name,
          integration: t("#{stub_integration_id}.name")
        )
      )
    end
  end

  describe "#unsuccessful_import" do
    it "includes a status message in the body" do
      mailer = stub_unsuccessful_mailer("greenhouse")

      expect(mailer.body.to_s).to include(
        t(
          "candidate_import_mailer.unsuccessful_import.message",
          candidate_name: stub_candidate.name,
          integration: t("greenhouse.name"),
          status_error: stub_status.error
        )
      )
    end

    context "icims" do
      it "includes a retry link in the body" do
        mailer = stub_unsuccessful_mailer("icims")
        expect(mailer.body.to_s).to include(
          t(
            "candidate_import_mailer." \
            "unsuccessful_import.icims_retry_instructions",
            icims_retry_link: icims_candidate_retry_import_url(
              stub_candidate.id
            )
          )
        )
      end
    end
  end

  def stub_integration_id
    "icims"
  end

  def stub_email
    "test@example.com"
  end

  def stub_candidate
    double(:candidate, id: 1, name: "First Last")
  end

  def stub_status
    double(:status, error: "An import error")
  end

  def stub_successful_mailer
    CandidateImportMailer.successful_import(
      candidate: stub_candidate,
      email: stub_email,
      integration_id: stub_integration_id,
    )
  end

  def stub_unsuccessful_mailer(integration_id)
    CandidateImportMailer.unsuccessful_import(
      candidate: stub_candidate,
      integration_id: integration_id,
      email: stub_email,
      status: stub_status
    )
  end
end
