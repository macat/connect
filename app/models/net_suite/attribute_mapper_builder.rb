class NetSuite::AttributeMapperBuilder
  def initialize(user:)
    @attribute_mapper = ::AttributeMapper.new(user: user)
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
      "home_phone" => "phone",
      "job_title" => "title",
      "last_name" => "lastName",
    }
  end

  private

  def build_field_mappings
    attribute_mapper.build_field_mappings(default_field_mapping)
  end

  attr_accessor :attribute_mapper
end
