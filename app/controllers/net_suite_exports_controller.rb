class NetSuiteExportsController < ApplicationController
  def create
    Delayed::Job.enqueue NetSuiteExportJob.new(current_user.id)
  end
end
