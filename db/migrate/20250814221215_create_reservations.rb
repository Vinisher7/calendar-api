class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.string :customer_name
      t.integer :total_amount_cents
      t.integer :signal_amount_cents
      t.datetime :entry_date_time
      t.datetime :out_date_time

      t.timestamps
    end
  end
end
