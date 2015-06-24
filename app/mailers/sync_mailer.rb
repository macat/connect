class SyncMailer < ApplicationMailer
  def net_suite_notification(email:, results:)
    @sync_results = SyncResults.new(results)

    mail(
      to: email,
      subject: t(
        "sync_mailer.net_suite_notification.subject",
        employees: @sync_results.employees(
          @sync_results.succeeded.count
        )
      )
    )
  end

  class SyncResults
    def initialize(results)
      @results = results
    end

    def succeeded
      @succeeded ||= @results.select(&:success?)
    end

    def succeeded_message
      I18n.t(
        "sync_mailer.net_suite_notification.succeeded",
        employees: employees(succeeded.count)
      )
    end

    def failed
      @failed ||= @results.reject(&:success?)
    end

    def failed_message
      I18n.t(
        "sync_mailer.net_suite_notification.failed",
        employees: employees(failed.count)
      )
    end

    def employees(count)
      I18n.t(
        "sync_mailer.net_suite_notification.employees",
        count: count
      )
    end
  end

  private_constant :SyncResults
end
