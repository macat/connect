module Greenhouse
  class AttributeMapper
    # Initializes an attribute mapper using Namely Fields
    def initialize(namely_fields)
      @fields = namely_fields
    end

    def call(payload)
      custom_fields(payload).
        merge(basic_fields(payload)).
        select { |_, value| value.present? }
    end

    def namely_identifier_field
      :greenhouse_id
    end

    private

    def basic_fields(payload)
      {
        first_name: candidate_for(application_for(payload)).fetch("first_name"),
        last_name: candidate_for(application_for(payload)).fetch("last_name"),
        email: email_for(candidate_for(application_for(payload))),
        user_status: "active",
        start_date: offer_for(application_for(payload)).fetch("starts_at"),
        home: home_address_for(candidate_for(application_for(payload))),
        namely_identifier_field => identifier(application_for(payload)).to_s,
        salary: salary_field(application_for(payload)),
      }
    end

    def custom_fields(payload)
      p = candidate_for(application_for(payload)).fetch("custom_fields", {})
      if p.present?
        Greenhouse::CustomFields.match(p, @fields)
      else
        {}
      end
    end

    def candidate_for(payload)
      payload.fetch("candidate")
    end

    def identifier(payload)
      payload.fetch("id")
    end

    def application_for(payload)
      payload.fetch("application")
    end

    def salary_field(payload)
      offer = offer_for(payload)
      custom_fields = offer.fetch("custom_fields", {})
      if custom_fields.present? && salary = custom_fields.fetch("salary")
        if salary.fetch("type") == "currency"
          {
            yearly_amount: salary.fetch("value").fetch("amount"),
            currency_type: salary.fetch("value").fetch("unit"),
            date: offer.fetch("starts_at")
          }
        else
          {
            yearly_amount: salary.fetch("value").to_i,
            currency_type: "USD",
            date: offer.fetch("starts_at")
          }
        end

      else
        {}
      end
    end

    def email_for(payload)
      email = payload.fetch("email_addresses", [])
      if email
        email = email.find do |email_address|
          email_address.fetch("type") == "personal"
        end || {}
        email.fetch("value")
      else
        ""
      end
    end

    def offer_for(payload)
      payload.fetch("offer", {"starts_at" => ""})
    end

    def home_address_for(candidate)
      home_address = candidate.fetch("addresses", [])
      if home_address
        home_address = home_address.find do |address|
          address.fetch("type") == "home"
        end || {}
        { address1: home_address.fetch("value", "") }
      else
        nil
      end
    end
  end
end
