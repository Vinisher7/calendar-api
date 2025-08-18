class CreateObservations < ActiveRecord::Migration[7.1]
  def change
    create_table :observations do |t|
      t.text :description

      t.timestamps
    end
  end
end
