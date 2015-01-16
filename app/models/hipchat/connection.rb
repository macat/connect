module Hipchat
  class Connection < ActiveRecord::Base
    belongs_to :user

    def connected?
      api_key.present?
    end
  end
end
