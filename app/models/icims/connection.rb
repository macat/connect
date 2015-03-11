module Icims
  class Connection < ActiveRecord::Base
    belongs_to :user

    def connected?
      username.present? && password.present?
    end
  end
end
