class SyncJob < ActiveJob::Base
  def perform(connection)
    return unless execute?(connection)

    Notifier.execute(connection) do
      connection.sync
    end
  end

  private

  def execute?(connection)
    return true unless connection.lockable?

    !connection.locked?
  end
end
