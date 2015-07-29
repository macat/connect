class AttributeMapper < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  has_many :field_mappings

  validates :user, presence: true
  validates :user_id, presence: true

  accepts_nested_attributes_for :field_mappings

  NAMELY_FIELDS = [
    :asset_management,
    :bio,
    :corporate_card_number,
    :current_job_description,
    :dental_info,
    :departure_date,
    :dob,
    :email,
    :emergency_contact,
    :emergency_contact_phone,
    :employee_handbook,
    :employee_id,
    :employee_wage_theft_prevention_act,
    :first_name,
    :gender,
    :healthcare_info,
    :home_phone,
    :image,
    :job_change_reason,
    :job_description,
    :job_title,
    :key_tag_number,
    :laptop_asset_number,
    :last_name,
    :life_insurance_info,
    :linkedin_url,
    :marital_status,
    :middle_name,
    :mobile_phone,
    :office_company_mobile,
    :office_direct_dial,
    :office_fax,
    :office_main_number,
    :office_phone,
    :personal_email,
    :preferred_name,
    :resume,
    :start_date,
    :test_custom_field,
    :user_status,
    :vision_plan_info,
  ]

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
end
