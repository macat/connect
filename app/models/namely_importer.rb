class NamelyImporter
  def self.import(*args)
    new(*args).import
  end

  def initialize(recent_hires:, namely_connection:, attribute_mapper:)
    @recent_hires = recent_hires
    @namely_connection = namely_connection
    @attribute_mapper = attribute_mapper
  end

  def import
    recent_hire_namely_attributes.each do |attrs|
      if valid_attributes?(attrs)
        namely_profiles.create!(attrs)
      end
    end
  end

  private

  attr_reader :recent_hires, :namely_connection, :attribute_mapper

  def recent_hire_namely_attributes
    recent_hires.map { |recent_hire| attribute_mapper.call(recent_hire) }
  end

  def namely_profiles
    namely_connection.profiles
  end

  def valid_attributes?(attrs)
    attrs[:email].present?
  end
end
