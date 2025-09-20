class AddColumnDateToObservations < ActiveRecord::Migration[7.1]
  def change
    add_column :observations, :date, :date
  end
end
