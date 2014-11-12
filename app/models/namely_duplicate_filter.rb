class NamelyDuplicateFilter
  def self.filter(recent_hires, options)
    new(options).filter(recent_hires)
  end

  def initialize(attribute_mapper:, namely_connection:)
    @attribute_mapper = attribute_mapper
    @namely_connection = namely_connection
  end

  def filter(unfiltered)
    unfiltered.reject do |row|
      identifier = attribute_mapper.identifier(row)
      imported_identifiers.include?(identifier)
    end
  end

  private

  attr_reader :attribute_mapper, :namely_connection

  def imported_identifiers
    @imported_identifiers ||= Set.new(profiles.map do |profile|
      profile.send(attribute_mapper.namely_identifier_field)
    end)
  end

  def profiles
    namely_connection.profiles.all
  end
end
