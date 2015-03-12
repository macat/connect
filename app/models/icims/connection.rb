module Icims
  class Connection < ActiveRecord::Base
    belongs_to :user

    def connected?
      username.present? && password.present?
    end

    def disconnect
      update(
        password: nil,
        username: nil,
      )
    end
  end
end
