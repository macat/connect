module Greenhouse
  class AttributeMapper
    def call(payload)
      {
        first_name: candidate_for(application_for(payload)).fetch('first_name'),
        last_name: candidate_for(application_for(payload)).fetch('last_name'),
        email: email_for(candidate_for(application_for(payload))),
        user_status: "active",
        start_date: offer_for(application_for(payload)).fetch('starts_at'),
        home: home_address_for(candidate_for(application_for(payload))),
        namely_identifier_field => identifier(application_for(payload)).to_s,
      }.select { |_, value| value.present? }
    end

    def namely_identifier_field
      :greenhouse_id
    end

    private

    def candidate_for(payload)
      payload.fetch('candidate')
    end

    def identifier(payload)
      payload.fetch('id')
    end

    def application_for(payload)
      payload.fetch('application')
    end

    def email_for(payload)
      payload.fetch('email_addresses').find do |email_address|
        email_address.fetch('type') == "personal"
      end.fetch('value')
    end

    def offer_for(payload)
      payload.fetch('offer', {'starts_at' => ''})
    end

    def home_address_for(candidate)
      home_address = candidate.fetch('addresses', [])
      if home_address 
        home_address = home_address.find do |address| 
          address.fetch('type') == "home"
        end || {}
        home_address.fetch('value', '')
      else 
        ''
      end
    end
  end
end
