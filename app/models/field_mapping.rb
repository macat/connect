class FieldMapping < ActiveRecord::Base
  belongs_to :attribute_mapper

  validates :attribute_mapper, presence: true
  validates :attribute_mapper_id, presence: true
  validates :integration_field_name, presence: true

  def self.map!(field, to: nil)
    if where(integration_field_name: field).empty?
      create!(integration_field_name: field, namely_field_name: to)
    end
  end

  def integration_key
    integration_field_name.underscore.parameterize("_")
  end
end
