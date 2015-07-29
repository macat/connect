class AttributeMapper < ActiveRecord::Base
  SUPPORTED_TYPES = %w(
    email
    longtext
    referencehistory
    referenceselect
    select
    text
  )
  # Unsupported: address checkboxes date file image salary

  belongs_to :user, dependent: :destroy
  has_many :field_mappings

  validates :user, presence: true
  validates :user_id, presence: true

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
      if profile.send(field_mapping.namely_field_name).present?
        accumulator.merge!(
          field_mapping.integration_field_name => profile.send(
            field_mapping.namely_field_name
          )
        )
      end
    end
  end

  def namely_fields
    user.
      namely_fields.
      all.
      select { |field| SUPPORTED_TYPES.include?(field.type) }.
      map { |field| [field.label, field.name] }
  end
end
