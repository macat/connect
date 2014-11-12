module Jobvite
  class AttributeMapper
    def call(jobvite_candidate)
      {
        first_name: jobvite_candidate.first_name,
        last_name: jobvite_candidate.last_name,
        email: jobvite_candidate.email,
        user_status: "active",
        start_date: jobvite_candidate.start_date.to_date.iso8601,
        gender: namely_genders[jobvite_candidate.gender],
      }
    end

    def namely_genders
      { "Male" => "male", "Female" => "female" }.tap do |genders|
        genders.default = "not specified"
      end
    end
  end
end
