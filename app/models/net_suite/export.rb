module NetSuite
  class Export
    def initialize(configuration:, namely_profiles:, net_suite:)
      @configuration = configuration
      @namely_profiles = namely_profiles
      @net_suite = net_suite
    end

    def perform
      namely_profiles.map do |profile|
        export(profile)
      end
    end

    protected

    attr_reader :namely_profiles

    private

    def export(profile)
      Employee.new(
        profile,
        configuration: @configuration,
        net_suite: @net_suite
      ).export
    end

    class Employee
      GENDER_MAP = {
        "Male" => "_male",
        "Female" => "_female",
        "Not specified" => "_omitted",
      }

      def initialize(profile, configuration:, net_suite:)
        @configuration = configuration
        @profile = profile
        @net_suite = net_suite
      end

      def export
        if persisted?
          update
        else
          create
        end
      end

      private

      def persisted?
        id.present?
      end

      def update
        response = @net_suite.update_employee(id, attributes)
        Result.new(response, true, @profile)
      end

      def create
        response = @net_suite.create_employee(attributes)

        if response.success?
          @profile.update(netsuite_id: response["internalId"])
        end

        Result.new(response, false, @profile)
      end

      def id
        @profile["netsuite_id"]
      end

      def attributes
        {
          firstName: @profile.first_name,
          lastName: @profile.last_name,
          email: @profile.email,
          gender: map_gender(@profile.gender),
          phone: @profile.home_phone,
          subsidiary: { internalId: @configuration.subsidiary_id },
          title: @profile.job_title[:title]
        }
      end

      def map_gender(namely_value)
        GENDER_MAP[namely_value]
      end
    end

    class Result
      def initialize(response, updated, profile)
        @response = response
        @updated = updated
        @profile = profile
      end

      delegate :success?, to: :response
      delegate :email, :first_name, :last_name, to: :profile

      def updated?
        @updated
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
