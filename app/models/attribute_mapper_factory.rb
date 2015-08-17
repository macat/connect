class AttributeMapperFactory
  def initialize(connection: , attribute_mapper:)
    @attribute_mapper = attribute_mapper
    @connection = connection
  end

  def build_with_defaults(&defaults)
    @attribute_mapper || assign_attribute_mapper(defaults)
  end

  private

  def assign_attribute_mapper(defaults)
    AttributeMapper.create!.tap do |attribute_mapper|
      @connection.update!(attribute_mapper: attribute_mapper)
      defaults.call.each do |integration_field_name, namely_field_name|
        attribute_mapper.field_mappings.create!(
          integration_field_name: integration_field_name,
          namely_field_name: namely_field_name
        )
      end
    end
  end
end
