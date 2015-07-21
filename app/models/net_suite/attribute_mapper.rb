class NetSuite::AttributeMapper
  delegate :call, to: :attribute_mapper
  delegate :field_mappings, to: :attribute_mapper
  delegate :mapping_direction, to: :attribute_mapper

  def initialize(attribute_mapper:, configuration:)
    @attribute_mapper = attribute_mapper
    @configuration = configuration
  end

  private

  attr_reader :attribute_mapper, :configuration
end
