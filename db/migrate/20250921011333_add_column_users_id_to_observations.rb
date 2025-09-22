class AddColumnUsersIdToObservations < ActiveRecord::Migration[7.1]
  def change
    add_reference :observations, :user, null: false, foreign_key: true
  end
end
