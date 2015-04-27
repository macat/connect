module Greenhouse
  class Connection < ActiveRecord::Base
    belongs_to :user

    def connected?
      token.present?
    end
  end
end
