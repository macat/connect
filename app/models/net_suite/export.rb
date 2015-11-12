module NetSuite
  class Export
    def self.perform(**args)
      new(args).perform
    end

    def initialize(summary_id:, normalizer:, namely_profiles:, net_suite_connection:)
      @summary_id = summary_id
      @normalizer = normalizer
      @namely_profiles = namely_profiles
      @net_suite_client = net_suite_connection.client
      @net_suite_connection = net_suite_connection
    end

    def perform
      matcher.results.each do |result|
        if result.matched?
          differ = NetSuite::EmployeeDiffer.new(
            namely_employee: normalize(result.namely_employee),
            netsuite_employee: result.netsuite_employee)
          if differ.different?
            NetSuiteExportJob.perform_later(
              "update",
              summary_id,
              net_suite_connection.id,
              result.profile.id,
              result.profile.name,
              result.namely_employee,
              result.netsuite_employee["internalId"]
            )
          end
        else
          NetSuiteExportJob.perform_later(
            "create",
            summary_id,
            net_suite_connection.id,
            result.profile.id,
            result.profile.name,
            result.namely_employee
          )
        end
      end

      []
    end

    private

    attr_reader :namely_profiles, :net_suite_client, :net_suite_connection,
                :normalizer, :summary_id

    def matcher
      @matcher ||= Matcher.new(
        mapper: normalizer,
        fields: ["email"],
        profiles: namely_profiles,
        employees: net_suite_client.employees)
    end

    def normalize(employee)
      NetSuite::DiffNormalizer.normalize(employee)
    end
  end
end
