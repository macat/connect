require 'rails_helper'

RSpec.describe Greenhouse::Connection, :type => :model do
  describe '#connected?' do 
    it 'returns true if token is set' do 
      connection = create :greenhouse_connection, :connected
      expect(connection.connected?).to eql true
    end

    it 'returns false if token is not set' do 
      connection = create :greenhouse_connection, :disconnected
      expect(connection.connected?).to eql false
    end
  end
end
