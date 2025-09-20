class AddColumnObservationToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :observation, :string
  end
end
