class AddColumnPaymentStatusToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :payment_status, :integer
  end
end
