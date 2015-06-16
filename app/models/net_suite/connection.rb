class NetSuite::Connection < ActiveRecord::Base
  belongs_to :user

  def connected?
    instance_id.present? && authorization.present?
  end

  def enabled?
    ENV["CLOUD_ELEMENTS_ORGANIZATION_SECRET"].present?
  end
end
