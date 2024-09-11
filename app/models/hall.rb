class Hall < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true

  has_many :seats
  has_many :showtimes
  after_create :generate_seats

  def generate_seats
    seat_types = {
      'A' => 'classic',
      'B' => 'classic',
      'C' => 'premium',
      'D' => 'premium',
      'E' => 'recliner'
    }
    seats_per_row = 10

    seat_types.each do |row, seat_type|
      (1..seats_per_row).each do |seat_num|
  
        Seat.create(
          seat_number: "#{row}#{seat_num}",
          seat_type: seat_type,
          hall: self
        )
      end
    end
  end
end
