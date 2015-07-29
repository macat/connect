class CandidateImporter
  attr_reader :connection, :params

  delegate :success?, to: :import_assistant

  def initialize(
    assistant_arguments: {},
    assistant_class:,
    connection:,
    mailer:,
    params:
  )
    @connection = connection
    @mailer = mailer
    @params = params
    @assistant_class = assistant_class
    @assistant_arguments = assistant_arguments
  end

  def import
    import_assistant.import_candidate
    report_import_results
  end

  def import_assistant
    @import_assistant ||= assistant_class.new(
      assistant_arguments: @assistant_arguments,
      context: self
    )
  end

  def namely_importer
    NamelyImporter.new(
      attribute_mapper: import_assistant.attribute_mapper,
      namely_connection: user.namely_connection
    )
  end

  def notifier
    AuthenticationNotifier.new(
      integration_id: assistant_class::INTEGRATION_ID,
      user: user
    )
  end

  def user
    connection.user
  end

  private

  def notify_of_successful_import
    mailer.delay.successful_import(
      candidate: import_assistant.candidate,
      email: user.email,
      integration_id: assistant_class::INTEGRATION_ID
    )
  end

  def notify_of_unsuccessful_import
    mailer.delay.unsuccessful_import(
      candidate: import_assistant.candidate,
      email: user.email,
      integration_id: assistant_class::INTEGRATION_ID,
      status: import_assistant.import_candidate
    )
  end

  def report_import_results
    if !import_assistant.skip_notification?
      if import_assistant.success?
        notify_of_successful_import
      else
        notify_of_unsuccessful_import
      end
    end
  end

  attr_reader :mailer, :assistant_class
end