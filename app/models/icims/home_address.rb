module Icims
  class HomeAddress
    def initialize(addresses)
      @addresses = addresses
    end

    def home_address
      if icims_home_address
        {
          address1: street1,
          address2: street2,
          city: city,
          country_id: country,
          state_id: state,
          zip: zip,
        }
      end
    end

    private

    attr_reader :addresses

    def street1
      icims_home_address["addressstreet1"]
    end

    def street2
      icims_home_address["addressstreet2"]
    end

    def city
      icims_home_address["addresscity"]
    end

    def country
      if icims_home_address["addresscountry"]
        icims_home_address["addresscountry"]["abbrev"]
      end
    end

    def state
      if icims_home_address["addressstate"]
        icims_home_address["addressstate"]["abbrev"]
      end
    end

    def zip
      icims_home_address["addresszip"]
    end

    def home_type?(address)
      address["addresstype"]["value"] == "Home"
    end

    def icims_home_address
      if addresses
        @icims_home_address ||=
          addresses.detect { |address| home_type?(address) }
      end
    end
  end
end
