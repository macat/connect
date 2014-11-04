class JobviteConnection < ActiveRecord::Base
  belongs_to :user

  def connected?
    api_key.present? && secret.present?
  end
end
