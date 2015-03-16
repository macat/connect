module Users
  class TokenExpiry
    def self.for(seconds)
      seconds.to_i.seconds.from_now
    end
  end
end
