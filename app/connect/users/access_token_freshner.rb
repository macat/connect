module Connect 
  module Users 
    class AccessTokenFreshner 
      def self.fresh_access_token(user) 
        new(user).fresh_access_token
      end

      def initialize(user) 
        @user = user 
      end 

      def fresh_access_token
        if access_token_expired?
          refresh_access_token
          user.save_token_info(tokens.fetch("access_token"), 
                               tokens.fetch("expires_in"))
        end
        user.access_token
      end

      private 

      def refresh_access_token 
        @tokens = authenticator.refresh_access_token(user.refresh_token)
      end

      def access_token_expired?
        Time.current > user.access_token_expiry
      end

      def authenticator
        Authenticator.new(user.subdomain)
      end

      attr_reader :user, :tokens
    end
  end
end
