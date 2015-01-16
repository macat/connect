module Hipchat
  class Connection < ActiveRecord::Base
    belongs_to :user

    def connected?
      api_key.present?
    end

    def disconnect
      update(api_key: nil)
    end
  end
end
