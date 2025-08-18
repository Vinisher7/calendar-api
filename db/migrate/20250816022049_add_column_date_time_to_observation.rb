class AddColumnDateTimeToObservation < ActiveRecord::Migration[7.1]
  def change
    add_column :observations, :date_time, :datetime
  end
end
