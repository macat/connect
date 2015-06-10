module Greenhouse
  class Connection < ActiveRecord::Base
    belongs_to :user
    validates :user_id, presence: true
    validates :secret_key, uniqueness: true
    before_create :set_secret_key

    def connected?
      name.present?
    end

    def missing_namely_field?
      if connected?
        UserCheckNamelyField.new(self).check?
      end
    end

    def disconnect
      update(name: nil)
    end

    def required_namely_field
      "greenhouse_id"
    end

    def set_secret_key
      self.secret_key = SecureRandom.hex(20)
    end
  end
end
