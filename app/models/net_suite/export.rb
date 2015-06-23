module NetSuite
  class Export
    def initialize(namely_profiles:, net_suite:)
      @namely_profiles = namely_profiles
      @net_suite = net_suite
    end

    def perform
      new_namely_profiles.map do |profile|
        export(profile)
      end
    end

    protected

    attr_reader :namely_profiles

    private

    def new_namely_profiles
      namely_profiles.select do |profile|
        profile["netsuite_id"].blank?
      end
    end

    def export(profile)
      response = @net_suite.create_employee(
        first_name: profile.first_name,
        last_name: profile.last_name,
        email: profile.email,
        gender: profile.gender,
        phone: profile.home_phone
      )

      if response.success?
        profile.update(netsuite_id: response["internalId"])
      end

      Result.new(response, profile)
    end

    class Result
      def initialize(response, profile)
        @response = response
        @profile = profile
      end

      delegate :success?, to: :response
      delegate :email, :first_name, :last_name, to: :profile

      def to_partial_path
        "net_suite_exports/result"
      end

      def message
        response["providerMessage"] || response["message"]
      end

      protected

      attr_reader :response, :profile
    end

    private_constant :Result
  end
end
