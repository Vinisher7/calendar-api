class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.integer :notification_type
      t.boolean :is_read

      t.timestamps
    end
  end
end
