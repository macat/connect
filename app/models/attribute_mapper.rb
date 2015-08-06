class AttributeMapper < ActiveRecord::Base
  SUPPORTED_TYPES = %w(
    date
    email
    longtext
    referencehistory
    referenceselect
    select
    text
  )
  # Unsupported: address checkboxes file image salary

  has_many :field_mappings, dependent: :destroy

  accepts_nested_attributes_for :field_mappings

  def build_field_mappings(default_field_mapping)
    default_field_mapping.each_pair do |namely_field, integration_field|
      field_mappings << FieldMapping.new(
        integration_field_name: integration_field.to_s,
        namely_field_name: namely_field
      )
    end
  end

  def export(profile)
    field_mappings.each_with_object({}) do |field_mapping, accumulator|
      value = profile[field_mapping.namely_field_name]
      if value.present?
        accumulator.merge!(field_mapping.integration_field_name => value)
      end
    end
  end

  def import(attributes)
    field_mappings.each_with_object({}) do |field_mapping, accumulator|
      value = attributes[field_mapping.integration_field_name.to_sym]
      if value.present?
        accumulator.merge!(field_mapping.namely_field_name.to_sym => value)
      end
    end
  end
end
