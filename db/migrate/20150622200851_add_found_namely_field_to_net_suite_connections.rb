class AddFoundNamelyFieldToNetSuiteConnections < ActiveRecord::Migration
  def change
    add_column(
      :net_suite_connections,
      :found_namely_field,
      :boolean,
      default: false,
      null: false
    )
  end
end
