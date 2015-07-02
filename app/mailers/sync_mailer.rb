class SyncMailer < ApplicationMailer
  def sync_notification(email:, integration_id:, results:)
    @integration_id = integration_id
    @sync_results = SyncResults.new(integration_id, results)

    mail(to: email, subject: @sync_results.subject)
  end

  class SyncResults
    def initialize(integration_id, results)
      @integration_id = integration_id
      @results = results
    end

    def subject
      t(
        "sync_mailer.sync_notification.subject",
        employees: employees(succeeded.count)
      )
    end

    def succeeded
      @succeeded ||= @results.select(&:success?)
    end

    def succeeded_message
      t(
        "sync_mailer.sync_notification.succeeded",
        employees: employees(succeeded.count)
      )
    end

    def failed
      @failed ||= @results.reject(&:success?)
    end

    def failed_message
      t(
        "sync_mailer.sync_notification.failed",
        employees: employees(failed.count)
      )
    end

    def employees(count)
      t(
        "sync_mailer.sync_notification.employees",
        count: count
      )
    end

    private

    def t(key, data = {})
      I18n.t(key, data.merge(integration: integration))
    end

    def integration
      I18n.t("#{@integration_id}.name")
    end
  end

  private_constant :SyncResults
end
