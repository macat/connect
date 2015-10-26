require "rails_helper"

describe SyncJob do
  it "runs a sync" do
    connection = build_stubbed(:net_suite_connection)
    allow(connection).to receive(:sync).and_return([])

    SyncJob.perform_now(connection)

    expect(connection).to have_received(:sync)
  end

  it "notifies of results" do
    connection = double(:connection, lockable?: false)
    allow(Notifier).to receive(:execute)

    SyncJob.perform_now(connection)

    expect(Notifier).to have_received(:execute).with(connection)
  end

  context 'when the connection is lockable' do
    let(:connection) { double(:connection, lockable?: true, sync: []) }

    before do
      allow(connection).to receive(:locked?).and_return(lock_state)
    end

    context 'and it is locked' do
      let(:lock_state) { true }

      it 'does not run a sync' do
        allow(connection).to receive(:sync).and_return([])

        SyncJob.perform_now(connection)

        expect(connection).to_not have_received(:sync)
      end
    end

    context 'and it is unlocked' do
      let(:connection) { build(:net_suite_connection, :ready) }
      let(:lock_state) { false }

      it 'runs a sync' do
        allow(connection).to receive(:sync).and_return([])

        SyncJob.perform_now(connection)

        expect(connection).to have_received(:sync)
      end
    end
  end
end
