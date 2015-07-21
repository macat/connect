class NetSuite::AttributeMapperBuilder
  def initialize(user:)
    @attribute_mapper = ::AttributeMapper.new(
      mapping_direction: :export,
      user: user
    )
  end

  def build
    attribute_mapper.save
    build_field_mappings
    attribute_mapper
  end

  def default_field_mapping
    {
      "email" => "email",
      "first_name" => "firstName",
      "gender" => "gender",
      "last_name" => "lastName",
      "home_phone" => "phone",
    }
  end

  private

  def build_field_mappings
    attribute_mapper.build_field_mappings(default_field_mapping)
  end

  attr_accessor :attribute_mapper
end
