module NetSuite
  class Export
    def initialize(attribute_mapper:, namely_profiles:, net_suite:)
      @attribute_mapper = attribute_mapper
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
        attribute_mapper: @attribute_mapper,
        net_suite: @net_suite
      ).export
    end

    class Employee
      def initialize(profile, attribute_mapper:, net_suite:)
        @attribute_mapper = attribute_mapper
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
        @attribute_mapper.export(@profile)
      end
    end

    class Result
      def initialize(response, updated, profile)
        @response = response
        @updated = updated
        @profile = profile
      end

      delegate :success?, to: :response
      delegate :email, :name, to: :profile

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
