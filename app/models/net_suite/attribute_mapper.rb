class NetSuite::AttributeMapper
  GENDER_MAP = {
    "Male" => "_male",
    "Female" => "_female",
    "Not specified" => "_omitted",
  }
  GENDER_MAP.default = "_omitted"

  delegate :field_mappings, to: :attribute_mapper
  delegate :mapping_direction, to: :attribute_mapper
  delegate :persisted?, to: :attribute_mapper

  def initialize(attribute_mapper:, configuration:)
    @attribute_mapper = attribute_mapper
    @configuration = configuration
  end

  def export(profile)
    attribute_mapper.export(profile)
  end

  def post_handle(exported_profile)
    exported_profile["gender"] = map_gender(exported_profile["gender"])
    exported_profile["subsidiary"] = set_subsidiary_id
    exported_profile["title"] = format_job_title(exported_profile["title"])

    exported_profile
  end

  private

  def format_job_title(value)
    value = Hash(value)
    value.fetch(:title) { "" }
  end

  def map_gender(value)
    GENDER_MAP[value]
  end

  def set_subsidiary_id
    { "internalId" => configuration.subsidiary_id }
  end

  attr_reader :attribute_mapper, :configuration
end
