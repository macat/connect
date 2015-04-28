module Greenhouse
  class AttributeMapper
    def call(greenhouse_candidate)
      {
        first_name: greenhouse_candidate.candidate.first_name,
        last_name: greenhouse_candidate.candidate.last_name,
        email: email_for(greenhouse_candidate),
        user_status: "active",
        start_date: greenhouse_candidate.offer.starts_at,
        home: home_address_for(greenhouse_candidate),
        namely_identifier_field => identifier(greenhouse_candidate).to_s,
      }.select { |_, value| value.present? }
    end

    def namely_identifier_field
      :greenhouse_id
    end

    private

    def identifier(candidate)
      candidate.application.id
    end

    def email_for(candidate)
      candidate.candidate.email_addresses.find do |email_address|
        email_address.type == "personal"
      end.value
    end

    def home_address_for(candidate)
      candidate.candidate.addresses.find do |address| 
        address.type == "home"
      end.value
    end
  end
end
