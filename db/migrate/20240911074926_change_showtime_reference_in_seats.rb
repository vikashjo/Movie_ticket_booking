class ChangeShowtimeReferenceInSeats < ActiveRecord::Migration[7.1]
  def change
    change_column_null :seats, :showtime_id, true
    add_reference :seats, :hall, null: true, foreign_key: true
    change_column :seats, :seat_number, :string
  end
end
