class RemoveShowtimeFromSeats < ActiveRecord::Migration[7.1]
  def change
    remove_reference :seats, :showtime, null: false, foreign_key: true
  end
end
