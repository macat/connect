module NetSuite
  class Export
    def self.perform(**args)
      new(args).perform
    end

    def initialize(normalizer:, namely_profiles:, net_suite:)
      @normalizer = normalizer
      @namely_profiles = namely_profiles
      @net_suite = net_suite
    end

    def perform
      matcher.results.map do |result|
        employee = Employee.new(profile: result.profile,
                                attributes: result.namely_employee,
                                net_suite: net_suite)

        if result.matched?
          differ = NetSuite::EmployeeDiffer.new(
            namely_employee: normalize(result.namely_employee),
            netsuite_employee: result.netsuite_employee)


          if differ.different?
            employee.update(result.netsuite_employee["internalId"])
          end
        else
          employee.create
        end
      end
    end

    private

    attr_reader :namely_profiles, :net_suite, :normalizer

    def matcher
      @matcher ||= Matcher.new(
        mapper: normalizer,
        fields: ["email"],
        profiles: namely_profiles,
        employees: net_suite.employees)
    end

    def normalize(employee)
      NetSuite::DiffNormalizer.normalize(employee)
    end

    class Employee
      def initialize(profile:, attributes:, net_suite:)
        @attributes = attributes
        @profile = profile
        @net_suite = net_suite
      end

      def update(id)
        request(updated: true) do
          response = @net_suite.update_employee(id, attributes)
          unless id == @profile.netsuite_id
            @profile.update(netsuite_id: id) 
          end
          response
        end
      end

      def create
        request(updated: false) do
          response = @net_suite.create_employee(attributes)
          @profile.update(netsuite_id: response["internalId"])
          response
        end
      end

      private

      attr_reader :attributes

      def request(updated:)
        yield
        Result.new(
          success: true,
          error: nil,
          updated: updated,
          profile: @profile
        )
      rescue NetSuite::ApiError => exception
        Result.new(
          success: false,
          error: exception.to_s,
          updated: updated,
          profile: @profile
        )
      end
    end

    class Result
      def initialize(success:, error:, updated:, profile:)
        @success = success
        @error = error
        @updated = updated
        @profile = profile
      end

      attr_reader :error
      delegate :email, :name, to: :profile

      def profile_id
        @profile.id
      end

      def success?
        @success == true
      end

      def updated?
        @updated
      end

      protected

      attr_reader :profile
    end

    private_constant :Result
  end
end
