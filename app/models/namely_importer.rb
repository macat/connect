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
    recent_hires.each do |recent_hire|
      namely_profiles.create!(attribute_mapper.call(recent_hire))
    end
  end

  private

  attr_reader :recent_hires, :namely_connection, :attribute_mapper

  def namely_profiles
    namely_connection.profiles
  end
end
