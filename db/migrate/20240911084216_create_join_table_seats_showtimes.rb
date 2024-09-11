class CreateJoinTableSeatsShowtimes < ActiveRecord::Migration[7.1]
  def change
    create_join_table :seats, :showtimes do |t|
      # t.index [:seat_id, :showtime_id]
      # t.index [:showtime_id, :seat_id]
    end
  end
end
