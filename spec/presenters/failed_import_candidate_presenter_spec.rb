require "rails_helper"

describe FailedImportCandidatePresenter do
  describe "#email" do
    it "displays email of candidate passed in" do
      candidate = double("candidate", email: "email@example.com")

      presenter = FailedImportCandidatePresenter.new(candidate, error)

      expect(presenter.email).to eq "email@example.com"
    end

    it "displays default when no email is present" do
      candidate = double("candidate")

      presenter = FailedImportCandidatePresenter.new(candidate, error)

      expect(presenter.email).to eq "noemail@example.com"
    end
  end

  def error
    double("error")
  end
end
