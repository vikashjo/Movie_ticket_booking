class CreateSeats < ActiveRecord::Migration[7.1]
  def change
    create_table :seats do |t|
      t.integer :seat_number
      t.string :seat_type
      t.integer :status, default: 0
      t.references :showtime, null: true, foreign_key: true

      t.timestamps
    end
  end
end
