class AddColumnUsersIdToPayments < ActiveRecord::Migration[7.1]
  def change
    add_reference :payments, :user, null: false, foreign_key: true
  end
end
