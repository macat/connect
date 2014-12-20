require "rails_helper"

describe Jobvite::Candidate do
  describe "#start_date" do
    before { Timecop.freeze }
    after { Timecop.return }

    it "returns the start date in ISO8601 format" do
      candidate = described_class.new("application" => {
        "startDate" => DateTime.now.to_i * 1000
      })

      expect(candidate.start_date).to eq Date.today.iso8601
    end

    it "returns nil when there is no start date" do
      candidate = described_class.new("application" => {
        "startDate" => nil
      })

      expect(candidate.start_date).to be_nil
    end
  end

  describe "#gender" do
    it "returns the gender from the application information" do
      gender = double("gender")
      candidate = described_class.new("application" => { "gender" => gender })

      expect(candidate.gender).to eq gender
    end
  end

  describe '#name' do 
    it 'returns the full from the application information' do 
      first_name = "Roger" 
      last_name = "Rult" 

      candidate = described_class.new("application" => { "first_name" => first_name, "last_name" => last_name}) 

      expect(candidate.name).to eql "#{first_name} #{last_name}"
    end
  end

  describe '#contact_number' do 
    let(:candidate) { described_class.new(application) } 

    context 'when just a home number is present' do 
      let(:application) { { "home_phone" => "888-888-8888" } }

      it 'returns the number' do 
        expect(candidate.contact_number).to eql "888-888-8888"
      end
    end

    context 'when just a work number is present' do 
      let(:application) { { "work_phone" => "889-888-8888" } }

      it 'returns the number' do 
        expect(candidate.contact_number).to eql "889-888-8888"
      end
    end

    context 'when just a mobile number is present' do 
      let(:application) { {"cell_phone" => "887-888-8888"} }

      it 'returns the number' do 
        expect(candidate.contact_number).to eql "887-888-8888"
      end
    end
  end
end
