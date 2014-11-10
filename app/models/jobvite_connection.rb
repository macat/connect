class JobviteConnection < ActiveRecord::Base
  belongs_to :user

  validates :hired_workflow_state, presence: true

  def connected?
    api_key.present? && secret.present?
  end

  def disconnect
    update(
      api_key: nil,
      secret: nil
    )
  end
end
